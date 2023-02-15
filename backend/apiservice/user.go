package apiservice

import (
	"context"
	"github.com/gofiber/fiber/v2"
	"strconv"
	db "tcd.ie/ase/group7/sustainablecity/db/sqlc"
	"tcd.ie/ase/group7/sustainablecity/util"
)

type createUserRequest struct {
	FirstName string `json:"firstName"`
	LastName  string `json:"lastName"`
}

func (server *Server) createUser(c *fiber.Ctx) error {
	req := new(createUserRequest)
	if err := c.BodyParser(req); err != nil {
		util.LogFatal("Failed to parse body:", err)
	}

	arg := db.CreateUserParams{
		FirstName: req.FirstName,
		LastName:  req.LastName,
	}

	user, err := server.store.CreateUser(context.Background(), arg)
	if err != nil {
		return util.ErrorResponse500(c, fiber.StatusInternalServerError, err)
	}

	return c.JSON(fiber.Map{
		"error":  false,
		"msg":    nil,
		"userId": user.UserID,
	})
}

func (server *Server) getUser(c *fiber.Ctx) error {
	id := c.Params("id")
	if id == "" {
		return util.ErrorResponse400(c, fiber.StatusBadRequest, "User id cannot be null")
	}

	userId, err := strconv.Atoi(id)
	if err != nil {
		return util.ErrorResponse500(c, fiber.StatusInternalServerError, err)
	}

	user, err := server.store.GetUser(context.Background(), int32(userId))
	if err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": true,
			"msg":   "user with this id not found",
			"user":  nil,
		})
	}

	return c.JSON(fiber.Map{
		"error": false,
		"msg":   nil,
		"user":  user,
	})
}
