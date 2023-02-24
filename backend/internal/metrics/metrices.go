package metrics

import (
	"fmt"

	"github.com/Eytins/sustainable-city-management/backend/config"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
)

type MicroserviceMetrics struct {
	SuccessHttpRequests prometheus.Counter
	ErrorHttpRequests   prometheus.Counter

	SuccessGrpcRequests prometheus.Counter
	ErrorGrpcRequests   prometheus.Counter
}

func NewMicroserviceMetrics(cfg *config.Config) *MicroserviceMetrics {
	return &MicroserviceMetrics{

		SuccessHttpRequests: promauto.NewCounter(prometheus.CounterOpts{
			Name: fmt.Sprintf("%s_success_http_requests_total", cfg.ServiceName),
			Help: "The total number of success http requests",
		}),
		ErrorHttpRequests: promauto.NewCounter(prometheus.CounterOpts{
			Name: fmt.Sprintf("%s_error_http_requests_total", cfg.ServiceName),
			Help: "The total number of error http requests",
		}),

		SuccessGrpcRequests: promauto.NewCounter(prometheus.CounterOpts{
			Name: fmt.Sprintf("%s_success_grpc_requests_total", cfg.ServiceName),
			Help: "The total number of success Grpc requests",
		}),
		ErrorGrpcRequests: promauto.NewCounter(prometheus.CounterOpts{
			Name: fmt.Sprintf("%s_error_grpc_requests_total", cfg.ServiceName),
			Help: "The total number of error Grpc requests",
		}),
	}
}
