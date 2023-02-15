package apiservice

import (
	"github.com/gofiber/fiber/v2"
	db "tcd.ie/ase/group7/sustainablecity/db/sqlc"
)

type Server struct {
	router *fiber.App
	store  *db.SQLStore
}

func NewServer(store *db.SQLStore) *Server {
	server := &Server{store: store}
	router := fiber.New(fiberConfig())

	// register api here
	router.Get("/hidocker", hidocker)
	router.Post("/user/create", server.createUser)
	router.Get("/user/:id", server.getUser)

	server.router = router

	return server
}

func fiberConfig() fiber.Config {
	return fiber.Config{
		// configure fiber here

	}
}

func (server *Server) Start(port string) error {
	return server.router.Listen(port)
}
