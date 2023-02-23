package gateway_service

import (
	db "github.com/Eytins/sustainable-city-management/backend/internal/db/sqlc"
	"github.com/gofiber/fiber/v2"
)

type GatewayService struct {
	router fiber.Router
	store  *db.SQLStore
}

func NewGatewayService(router fiber.Router, store *db.SQLStore) *GatewayService {
	server := &GatewayService{router: router, store: store}

	router.Post("/register", server.Register)
	router.Post("/login", server.Login)
	router.Get("/logout", server.Logout)
	router.Get("/profile", server.GetProfile)
	return server
}
