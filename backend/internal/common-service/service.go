package common_service

import (
	"context"
	"fmt"
	"net"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/Eytins/sustainable-city-management/backend/config"
	"github.com/Eytins/sustainable-city-management/backend/pkg/constants"
	"github.com/Eytins/sustainable-city-management/backend/pkg/logger"
	"github.com/gofiber/fiber"

	"github.com/go-playground/validator"
	"google.golang.org/grpc"
)

const (
	waitShotDownDuration = 3 * time.Second
	maxHeaderBytes       = 1 << 20
	stackSize            = 1 << 10 // 1 KB
	bodyLimit            = "2M"
	readTimeout          = 15 * time.Second
	writeTimeout         = 15 * time.Second
	gzipLevel            = 5
)

type service struct {
	log               logger.Logger
	cfg               *config.Config
	doneCh            chan struct{}
	validate          *validator.Validate
	healthCheckServer *http.Server
	grpcServer        *grpc.Server
	fiber             *fiber.App
	// metrics           *metrics.SearchMicroserviceMetrics
}

func NewService(log logger.Logger, cfg *config.Config) *service {
	return &service{log: log, cfg: cfg, validate: validator.New(), doneCh: make(chan struct{})}
}

func (a *service) Run() error {
	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM, syscall.SIGINT)
	defer cancel()

	// a.metrics = metrics.NewSearchMicroserviceMetrics(a.cfg)
	if a.cfg.ServiceType == "gateway" {
		a.fiber = fiber.New()
		go func() {
			if err := a.fiber.Listen(fmt.Sprintf(":%s", a.cfg.Http.Port)); err != nil {
				a.log.Errorf("(grpc server) err: %v", err)
				cancel()
			}
		}()
	} else {
		a.grpcServer = grpc.NewServer()
		go func() {
			listener, err := net.Listen(constants.Tcp, fmt.Sprintf(":%s", a.cfg.GRPC.Port))
			if err != nil {
				a.log.Errorf("(Net Listener) err: %v", err)
				cancel()
			}
			if err := a.grpcServer.Serve(listener); err != nil {
				a.log.Errorf("(Grpc server) err: %v", err)
				cancel()
			}
		}()
	}
	a.runHealthCheck(ctx)
	a.log.Infof("%s is listening on PORT: %v", GetMicroserviceName(a.cfg), a.cfg.Http.Port)

	<-ctx.Done()
	a.waitShootDown(waitShotDownDuration)

	if err := a.shutDownHealthCheckServer(ctx); err != nil {
		a.log.Warnf("(shutDownHealthCheckServer) HealthCheckServer err: %v", err)
	}

	<-a.doneCh
	a.log.Infof("%s Service exited properly", GetMicroserviceName(a.cfg))
	return nil
}
