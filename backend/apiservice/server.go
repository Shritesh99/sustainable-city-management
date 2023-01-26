package apiservice

import (
	"github.com/gofiber/fiber/v2"
)

type Server struct {
	router *fiber.App
}

func NewServer() *Server {
	server := &Server{}
	router := fiber.New(fiberConfig())
	
	// register api here
	router.Get("/", example)

	server.router = router

	return server
}

func fiberConfig() fiber.Config {
	return fiber.Config {
		// configure fiber here
		
	}
}

func (server *Server) Start(address string) error {
	return server.router.Listen(address)
}