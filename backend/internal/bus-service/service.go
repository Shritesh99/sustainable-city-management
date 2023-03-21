package bus_service

import (
	"github.com/Eytins/sustainable-city-management/backend/config"
	db "github.com/Eytins/sustainable-city-management/backend/internal/db/sqlc"
	"github.com/Eytins/sustainable-city-management/backend/pkg/logger"
	"google.golang.org/grpc"
)

type BusService struct {
	server *grpc.Server
	store  *db.SQLStore
	cfg    *config.Config
	log    logger.Logger
}

func NewBusService(server *grpc.Server, store *db.SQLStore, cfg *config.Config, logger2 logger.Logger) *BusService {
	service := &BusService{server: server, store: store, cfg: cfg, log: logger2}

	//server.CollectStationData()
	return service
}
