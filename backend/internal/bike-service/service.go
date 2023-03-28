package bike_service

import (
	"github.com/Eytins/sustainable-city-management/backend/config"
	db "github.com/Eytins/sustainable-city-management/backend/internal/db/sqlc"
	pb "github.com/Eytins/sustainable-city-management/backend/pb/bike/bike-pd"
	"github.com/Eytins/sustainable-city-management/backend/pkg/logger"
)

type BikeService struct {
	pb.UnimplementedBikeServiceServer
	store *db.SQLStore
	cfg   *config.Config
	log   logger.Logger
}

func NewBikeService(store *db.SQLStore, cfg *config.Config, logger2 logger.Logger) *BikeService {
	service := &BikeService{store: store, cfg: cfg, log: logger2}

	return service
}
