package common_service

import (
	"context"
	"fmt"
	"net/http"
	"time"

	"github.com/heptiolabs/healthcheck"
)

func (a *service) runHealthCheck(ctx context.Context) {
	health := healthcheck.NewHandler()
	mux := http.NewServeMux()
	mux.HandleFunc(a.cfg.Probes.LivenessPath, health.LiveEndpoint)
	mux.HandleFunc(a.cfg.Probes.ReadinessPath, health.ReadyEndpoint)

	a.healthCheckServer = &http.Server{
		Handler:      mux,
		Addr:         a.cfg.Probes.Port,
		WriteTimeout: writeTimeout,
		ReadTimeout:  readTimeout,
	}

	a.configureHealthCheckEndpoints(ctx, health)

	go func() {
		a.log.Infof("(%s) Kubernetes probes listening on port: %s", a.cfg.ServiceName, a.cfg.Probes.Port)
		if err := a.healthCheckServer.ListenAndServe(); err != nil {
			a.log.Errorf("(ListenAndServe) err: %v", err)
		}
	}()
}

func (a *service) configureHealthCheckEndpoints(ctx context.Context, health healthcheck.Handler) {
	// TODO: Check db service
	for _, s := range a.cfg.ConnectedServices {
		health.AddReadinessCheck(fmt.Sprintf("%s Health Readiness", s.ServiceName), healthcheck.HTTPGetCheck(fmt.Sprintf("%s:%s%s", s.ServiceUrl, s.HealthcheckPort, a.cfg.Probes.ReadinessPath), 500*time.Millisecond))
		health.AddReadinessCheck(fmt.Sprintf("%s Health Liveness", s.ServiceName), healthcheck.HTTPGetCheck(fmt.Sprintf("%s:%s%s", s.ServiceUrl, s.HealthcheckPort, a.cfg.Probes.LivenessPath), 500*time.Millisecond))
	}
}

func (a *service) shutDownHealthCheckServer(ctx context.Context) error {
	return a.healthCheckServer.Shutdown(ctx)
}
