package common_service

import (
	"context"
	"net/http"

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

	go func() {
		a.log.Infof("(%s) Kubernetes probes listening on port: %s", a.cfg.ServiceName, a.cfg.Probes.Port)
		if err := a.healthCheckServer.ListenAndServe(); err != nil {
			a.log.Errorf("(ListenAndServe) err: %v", err)
		}
	}()
}

func (a *service) shutDownHealthCheckServer(ctx context.Context) error {
	return a.healthCheckServer.Shutdown(ctx)
}
