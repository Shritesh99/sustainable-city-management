package airquality_service

import (
	"github.com/Eytins/sustainable-city-management/backend/config"
	db "github.com/Eytins/sustainable-city-management/backend/internal/db/sqlc"
	"google.golang.org/grpc"
)

type AirService struct {
	server *grpc.Server
	store  *db.SQLStore
	cfg    *config.Config
}

func NewAirService(server *grpc.Server, store *db.SQLStore, cfg *config.Config) *AirService {
	service := &AirService{server: server, store: store, cfg: cfg}

	//server.CollectStationData()
	return service
}
