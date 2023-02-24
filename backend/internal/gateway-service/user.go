package gateway_service

import (
	"context"
	_ "encoding/json"
	"fmt"
	_ "net/http"
	"time"

	db "github.com/Eytins/sustainable-city-management/backend/internal/db/sqlc"
	"github.com/Eytins/sustainable-city-management/backend/internal/util"
	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

var jwtKey = []byte("tasty_kimchi")

type RegisterRequest struct {
	FirstName string `json:"first_name"`
	LastName  string `json:"last_name"`
	RoleID    int32  `json:"role_id"`
	Username  string `json:"username"`
	Password  string `json:"password"`
}

// Create a struct to read the username and password from the request body
type LoginRequest struct {
	Password string `json:"password"`
	Username string `json:"username"`
}

// Create a struct to read the username
type LogoutRequest struct {
	Username string `json:"username"`
}

type UserInfoRequest struct {
	Username string `json:"username"`
}

type TokenStruct struct {
	TokenString string `json:"token"`
}

// Create a struct that will be encoded to a JWT.
// We add jwt.RegisteredClaims as an embedded type, to provide fields like expiry time
type Claims struct {
	Username string `json:"username"`
	jwt.RegisteredClaims
}

func (server *GatewayService) Register(c *fiber.Ctx) error {
	req := new(RegisterRequest)
	if err := c.BodyParser(req); err != nil {
		util.LogFatal("Failed to parse body:", err)
	}

	// fmt.Printf("[Register] username: %s, password: %s\n", req.Username, req.Password)

	argCheck := db.CreateLoginDetailParams{
		Email:    req.Username,
		Password: req.Password,
	}

	loginInfo, err := server.store.GetLoginDetail(context.Background(), argCheck.Email)

	if loginInfo.Email == req.Username {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": true,
			"msg":   "This email has been registered!",
		})
	}

	arg := db.CreateUserParams{
		FirstName: req.FirstName,
		LastName:  req.LastName,
	}

	user, err := server.store.CreateUser(context.Background(), arg)
	if err != nil {
		// fmt.Printf("[CreateUser] %s\n", err)
		return util.ErrorResponse500(c, fiber.StatusInternalServerError, err)
	}

	argLogin := db.CreateLoginDetailParams{
		RoleID:   req.RoleID,
		UserID:   user.UserID,
		Email:    req.Username,
		Password: req.Password,
	}

	loginDetails, err := server.store.CreateLoginDetail(context.Background(), argLogin)
	if err != nil {
		// fmt.Printf("[CreateLoginDetail] %s\n", err)
		return util.ErrorResponse500(c, fiber.StatusInternalServerError, err)
	}
	return c.JSON(fiber.Map{
		"error":  false,
		"msg":    "success",
		"userId": user.UserID,
		// "roleID":   loginDetails.RoleID,
		"email": loginDetails.Email,
		// "password": loginDetails.Password,
	})
}

// Create the Signin handler
func (server *GatewayService) Login(c *fiber.Ctx) error {
	// fmt.Printf("[Login]\n")
	req := new(LoginRequest)
	// Get the JSON body and decode into LoginRequest
	if err := c.BodyParser(req); err != nil {
		util.LogFatal("Failed to parse body:", err)
	}

	// fmt.Printf("[Login] username: %s, password: %s\n", req.Username, req.Password)

	arg := db.CreateLoginDetailParams{
		Email:    req.Username,
		Password: req.Password,
	}

	loginDetails, err := server.store.GetLoginDetail(context.Background(), arg.Email)
	if err != nil {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"error": true,
			"msg":   "This email is not registered! Please check your email id or Register your email",
		})
	}

	if loginDetails.Password != arg.Password {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"error": true,
			"msg":   "Incorrect Password",
		})
	}

	// Declare the expiration time of the token
	// here, we have kept it as 5 hours
	expirationTime := time.Now().Add(5 * time.Hour)
	// expirationTime := time.Now().Add(1 * time.Minute)
	// Create the JWT claims, which includes the username and expiry time
	claims := &Claims{
		Username: req.Username,
		RegisteredClaims: jwt.RegisteredClaims{
			// In JWT, the expiry time is expressed as unix milliseconds
			ExpiresAt: jwt.NewNumericDate(expirationTime),
		},
	}

	// Declare the token with the algorithm used for signing, and the claims
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	// Create the JWT string
	tokenString, err := token.SignedString(jwtKey)
	if err != nil {
		return c.Status(fiber.StatusFailedDependency).JSON(fiber.Map{
			"error": true,
			"msg":   "Error while creating token",
		})
	}
	// Finally, we set the client cookie for "token" as the JWT we just generated
	// we also set an expiry time which is the same as the token itself
	userInfo, err := server.store.GetUser(context.Background(), loginDetails.UserID)

	//cookie := fiber.Cookie{
	//	Name:     "jwt",
	//	Value:    tokenString,
	//	Expires:  expirationTime,
	//	HTTPOnly: true,
	//}

	//c.Cookie(&cookie)

	return c.JSON(fiber.Map{
		"error":     false,
		"msg":       "success",
		"userId":    loginDetails.UserID,
		"email":     loginDetails.Email,
		"roleId":    loginDetails.RoleID,
		"firstName": userInfo.FirstName,
		"lastName":  userInfo.LastName,
		"expires":   expirationTime.Unix(),
		"Token":     tokenString,
	})
}

func (server *GatewayService) GetProfile(c *fiber.Ctx) error {

	// check auth
	tknStr := c.Get("Token")
	var authorization = server.Authenticate(tknStr)
	if !authorization {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"error": true,
			"msg":   "Invalid Token",
			"user":  nil,
		})
	}

	req := new(UserInfoRequest)

	if err := c.BodyParser(req); err != nil {
		util.LogFatal("Failed to parse body:", err)
	}

	arg := db.CreateLoginDetailParams{
		Email: req.Username,
	}

	loginDetails, err := server.store.GetLoginDetail(context.Background(), arg.Email)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": true,
			"msg":   "This email is not registered! Please check your email id or Register your email",
		})
	}

	userInfo, err := server.store.GetUser(context.Background(), loginDetails.UserID)
	return c.JSON(fiber.Map{
		"error":     false,
		"msg":       "success",
		"userId":    loginDetails.UserID,
		"email":     loginDetails.Email,
		"roleId":    loginDetails.RoleID,
		"firstName": userInfo.FirstName,
		"lastName":  userInfo.LastName,
	})
}

func (server *GatewayService) Logout(c *fiber.Ctx) error {
	var tknStr = c.Get("Token")
	req := new(LogoutRequest)
	// Get the JSON body and decode into LogoutRequest
	if err := c.BodyParser(req); err != nil {
		util.LogFatal("Failed to parse body:", err)
	}
	fmt.Printf("[Logout] username: %s\n", req.Username)
	var authorization = server.Authenticate(tknStr)
	if !authorization {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"error": true,
			"msg":   "Invalid Token",
			"user":  nil,
		})
	}

	expirationTime := time.Now()
	// Create the JWT claims, which includes the username and expiry time
	claims := &Claims{
		Username: req.Username,
		RegisteredClaims: jwt.RegisteredClaims{
			// In JWT, the expiry time is expressed as unix milliseconds
			ExpiresAt: jwt.NewNumericDate(expirationTime),
		},
	}

	return c.JSON(fiber.Map{
		"expires": claims.ExpiresAt,
		"error":   false,
		"msg":     "success",
	})

}

type createLoginRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

func (server *GatewayService) validateUser(c *fiber.Ctx) error {
	req := new(createLoginRequest)
	if err := c.BodyParser(req); err != nil {
		util.LogFatal("Failed to parse body:", err)
	}

	arg := db.CreateLoginDetailParams{
		Email:    req.Email,
		Password: req.Password,
	}

	loginDetails, err := server.store.GetLoginDetail(context.Background(), arg.Email)
	if err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": true,
			"msg":   "This email is not registered! Please check your email id or Register your email",
		})
	}

	if loginDetails.Password != arg.Password {
		return c.Status(fiber.StatusOK).JSON(fiber.Map{
			"error": true,
			"msg":   "Incorrect Password",
		})
	}
	return c.JSON(fiber.Map{
		"error":        false,
		"msg":          nil,
		"loginDetails": loginDetails,
	})
}

func (server *GatewayService) Authenticate(tknStr string) bool {
	// Initialize a new instance of `Claims`
	claims := &Claims{}

	tkn, err := jwt.ParseWithClaims(tknStr, claims, func(token *jwt.Token) (interface{}, error) {
		return jwtKey, nil
	})
	if err != nil {
		return false
	}
	if !tkn.Valid {
		return false
	}
	return true
}
