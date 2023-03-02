package gateway_service

import (
	"github.com/Eytins/sustainable-city-management/backend/config"
	db "github.com/Eytins/sustainable-city-management/backend/internal/db/sqlc"
	"github.com/Eytins/sustainable-city-management/backend/pkg/logger"
	"github.com/gofiber/fiber/v2"
)

type GatewayService struct {
	log    logger.Logger
	router fiber.Router
	store  *db.SQLStore
	cfg    *config.Config
}

func NewGatewayService(router fiber.Router, store *db.SQLStore, cfg *config.Config, logger2 logger.Logger) *GatewayService {
	server := &GatewayService{router: router, store: store, cfg: cfg, log: logger2}
	router.Post("/register", server.Register)
	router.Post("/login", server.Login)
	router.Post("/logout", server.Logout)
	router.Post("/profile", server.GetProfile)
	router.Get("/airservicedata", server.GetAirData)
	router.Get("/roles", server.GetRoles)

	err := server.CollectStationData()
	if err != nil {
		return nil
	}
	return server
}
