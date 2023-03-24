package bus_service

import (
	"github.com/Eytins/sustainable-city-management/backend/config"
	db "github.com/Eytins/sustainable-city-management/backend/internal/db/sqlc"
	pb "github.com/Eytins/sustainable-city-management/backend/pb/bus/bus-pd"
	"github.com/Eytins/sustainable-city-management/backend/pkg/logger"
)

type BusService struct {
	pb.UnimplementedBusServiceServer
	store *db.SQLStore
	cfg   *config.Config
	log   logger.Logger
}

func NewBusService(store *db.SQLStore, cfg *config.Config, logger2 logger.Logger) *BusService {
	service := &BusService{store: store, cfg: cfg, log: logger2}

	return service
}
