package apiservice

import "github.com/gofiber/fiber/v2"

func hidocker(c *fiber.Ctx) error {
	return c.SendString("Hi, Docker! >3 ")
}