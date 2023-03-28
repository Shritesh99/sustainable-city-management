package bin_service

import (
	"github.com/Eytins/sustainable-city-management/backend/config"
	db "github.com/Eytins/sustainable-city-management/backend/internal/db/sqlc"
	pb "github.com/Eytins/sustainable-city-management/backend/pb/bin/bin-pd"
	"github.com/Eytins/sustainable-city-management/backend/pkg/logger"
)

type BinService struct {
	pb.UnimplementedBinServiceServer
	store *db.SQLStore
	cfg   *config.Config
	log   logger.Logger
}

func NewBinService(store *db.SQLStore, cfg *config.Config, logger2 logger.Logger) *BinService {
	service := &BinService{store: store, cfg: cfg, log: logger2}

	return service
}
