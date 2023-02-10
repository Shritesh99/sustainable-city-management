package common_service

// import (
// 	"context"
// 	"github.com/prometheus/client_golang/prometheus/promhttp"
// )

// func (a *service) runMetrics(cancel context.CancelFunc) {
// 	a.metricsServer = echo.New()
// 	go func() {
// 		a.metricsServer.Use(middleware.RecoverWithConfig(middleware.RecoverConfig{
// 			StackSize:         stackSize,
// 			DisablePrintStack: false,
// 			DisableStackAll:   false,
// 		}))

// 		a.metricsServer.GET(a.cfg.Probes.PrometheusPath, echo.WrapHandler(promhttp.Handler()))
// 		a.log.Infof("Metrics app is running on port: %s", a.cfg.Probes.PrometheusPort)
// 		if err := a.metricsServer.Start(a.cfg.Probes.PrometheusPort); err != nil {
// 			a.log.Errorf("metricsServer.Start: %v", err)
// 			cancel()
// 		}
// 	}()
// }
