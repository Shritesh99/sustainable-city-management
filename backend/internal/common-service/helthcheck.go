package common_service

import (
	"context"
	"fmt"
	"net/http"
	"time"

	"github.com/Eytins/sustainable-city-management/backend/config"
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
		health.AddReadinessCheck(fmt.Sprintf("%s Health Readiness", s.ServiceName), healthcheck.HTTPGetCheck(fmt.Sprintf("http://%s:%s%s", s.ServiceUrl, s.HealthcheckPort, a.cfg.Probes.ReadinessPath), 5*time.Minute))
		health.AddReadinessCheck(fmt.Sprintf("%s Health Liveness", s.ServiceName), healthcheck.HTTPGetCheck(fmt.Sprintf("http://%s:%s%s", s.ServiceUrl, s.HealthcheckPort, a.cfg.Probes.LivenessPath), 5*time.Minute))
		quit := make(chan struct{})
		ticker := time.NewTicker(5 * time.Second)
		go func(s config.Services) {
			for {
				select {
				case <-ticker.C:
					if err := healthcheck.HTTPGetCheck(fmt.Sprintf("http://%s:%s%s", s.ServiceUrl, s.HealthcheckPort, a.cfg.Probes.ReadinessPath), 5*time.Minute)(); err != nil {
						a.log.Errorf("(Health Liveness for %s) err: %v", s.ServiceName, err)
					}
					a.log.Infof("(Health Liveness for %s)", s.ServiceName)
					if err := healthcheck.HTTPGetCheck(fmt.Sprintf("http://%s:%s%s", s.ServiceUrl, s.HealthcheckPort, a.cfg.Probes.LivenessPath), 5*time.Minute)(); err != nil {
						a.log.Errorf("(Health Readiness for %s) err: %v", s.ServiceName, err)
					}
					a.log.Infof("(Health Readiness for %s)", s.ServiceName)
				case <-quit:
					ticker.Stop()
					return
				}
			}
		}(s)
	}
}

func (a *service) shutDownHealthCheckServer(ctx context.Context) error {
	return a.healthCheckServer.Shutdown(ctx)
}
