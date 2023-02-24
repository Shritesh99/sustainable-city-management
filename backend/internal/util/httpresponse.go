package util

import "github.com/gofiber/fiber/v2"

func ErrorResponse400(c *fiber.Ctx, code int, msg string) error {
	return c.Status(code).JSON(fiber.Map{
		"error": true,
		"msg":   msg,
	})
}

func ErrorResponse500(c *fiber.Ctx, code int, err error) error {
	return c.Status(code).SendString(err.Error())
}
