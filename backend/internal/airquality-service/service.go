package airquality_service

import (
	"github.com/Eytins/sustainable-city-management/backend/config"
	db "github.com/Eytins/sustainable-city-management/backend/internal/db/sqlc"
	pb "github.com/Eytins/sustainable-city-management/backend/pb/air-quality/air-pd"
	"github.com/Eytins/sustainable-city-management/backend/pkg/logger"
)

type AirService struct {
	pb.UnimplementedAirServiceServer
	store *db.SQLStore
	cfg   *config.Config
	log   logger.Logger
}

func NewAirService(store *db.SQLStore, cfg *config.Config, logger2 logger.Logger) *AirService {
	service := &AirService{store: store, cfg: cfg, log: logger2}

	return service
}
