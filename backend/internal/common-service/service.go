package common_service

import (
	"context"
	"database/sql"
	"fmt"
	airquality_service "github.com/Eytins/sustainable-city-management/backend/internal/airquality-service"
	"net"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/Eytins/sustainable-city-management/backend/config"
	"github.com/Eytins/sustainable-city-management/backend/internal/conf"
	db "github.com/Eytins/sustainable-city-management/backend/internal/db/sqlc"
	gateway_service "github.com/Eytins/sustainable-city-management/backend/internal/gateway-service"
	"github.com/Eytins/sustainable-city-management/backend/internal/metrics"
	"github.com/Eytins/sustainable-city-management/backend/pkg/constants"
	"github.com/Eytins/sustainable-city-management/backend/pkg/logger"
	"github.com/Eytins/sustainable-city-management/backend/pkg/middlewares"
	"github.com/go-playground/validator"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/labstack/echo"
	_ "github.com/lib/pq"
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
	metrics           *metrics.MicroserviceMetrics
	metricsServer     *echo.Echo
	middlewareManager middlewares.MiddlewareManager
	gatewayService    *gateway_service.GatewayService
	airService        *airquality_service.AirService
}

func NewService(log logger.Logger, cfg *config.Config) *service {
	return &service{log: log, cfg: cfg, validate: validator.New(), doneCh: make(chan struct{})}
}

func (a *service) Run() error {
	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM, syscall.SIGINT)
	defer cancel()

	conn, err := sql.Open(a.cfg.DB.DB_DRIVER, a.cfg.DB.DB_SOURCE)
	if err != nil {
		a.log.Errorf("(DB) err: %v", err)
	}

	a.middlewareManager = middlewares.NewMiddlewareManager(a.log, a.cfg, a.getHttpMetricsCb())
	a.metrics = metrics.NewMicroserviceMetrics(a.cfg)
	if a.cfg.ServiceType == "gateway" {
		a.fiber = fiber.New()
		a.fiber.Use(cors.New(conf.GetCorsConf()))
		gateway := a.fiber.Group("/auth")

		a.gatewayService = gateway_service.NewGatewayService(gateway, db.NewStore(conn), a.cfg, a.log)

		go func() {
			if err := a.fiber.Listen(fmt.Sprintf(":%s", a.cfg.Http.Port)); err != nil {
				a.log.Errorf("(grpc server) err: %v", err)
				cancel()
			}
		}()
	} else {
		a.grpcServer = grpc.NewServer()
		a.airService = airquality_service.NewAirService(a.grpcServer, db.NewStore(conn), a.cfg)
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
	a.runMetrics(cancel)
	a.runHealthCheck(ctx)
	a.log.Infof("%s is listening on PORT: %v", GetMicroserviceName(a.cfg), a.cfg.Http.Port)

	<-ctx.Done()
	a.waitShootDown(waitShotDownDuration)

	if err := a.shutDownHealthCheckServer(ctx); err != nil {
		a.log.Warnf("(shutDownHealthCheckServer) HealthCheckServer err: %v", err.Error())
	}

	<-a.doneCh
	a.log.Infof("%s Service exited properly", GetMicroserviceName(a.cfg))
	return nil
}
