package apiservice

import "github.com/gofiber/fiber/v2"

func example(c *fiber.Ctx) error {
	return c.SendString("Hello, World!")
}