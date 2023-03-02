package gateway_service

import (
	"github.com/Eytins/sustainable-city-management/backend/config"
	db "github.com/Eytins/sustainable-city-management/backend/internal/db/sqlc"
	"github.com/gofiber/fiber/v2"
)

type GatewayService struct {
	router fiber.Router
	store  *db.SQLStore
	cfg    *config.Config
}

func NewGatewayService(router fiber.Router, store *db.SQLStore, cfg *config.Config) *GatewayService {
	server := &GatewayService{router: router, store: store, cfg: cfg}
	router.Post("/register", server.Register)
	router.Post("/login", server.Login)
	router.Post("/logout", server.Logout)
	router.Post("/profile", server.GetProfile)
	router.Get("/airservicedata", server.GetAirData)

	server.CollectStationData()
	return server
}
