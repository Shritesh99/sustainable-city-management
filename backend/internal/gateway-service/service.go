package gateway_service

import (
	"github.com/Eytins/sustainable-city-management/backend/config"
	db "github.com/Eytins/sustainable-city-management/backend/internal/db/sqlc"
	"github.com/Eytins/sustainable-city-management/backend/pkg/logger"
	"github.com/gofiber/fiber/v2"
	"google.golang.org/grpc"
)

type GatewayService struct {
	log           logger.Logger
	router        fiber.Router
	store         *db.SQLStore
	cfg           *config.Config
	airClientConn *grpc.ClientConn
}

func NewGatewayService(router fiber.Router, store *db.SQLStore, cfg *config.Config, logger2 logger.Logger, airClientConn *grpc.ClientConn) *GatewayService {
	server := &GatewayService{router: router, store: store, cfg: cfg, log: logger2, airClientConn: airClientConn}
	router.Post("/register", server.Register)
	router.Post("/login", server.Login)
	router.Post("/logout", server.Logout)
	router.Post("/profile", server.GetProfile)
	router.Get("/airstationdata", server.GetAirData)
	router.Get("/roles", server.GetRoles)
	router.Get("/airdata", server.GetAQI)

	err := server.CollectStationData()
	if err != nil {
		return nil
	}
	err = server.SaveNoiseData()
	if err != nil {
		return nil
	}
	return server
}
