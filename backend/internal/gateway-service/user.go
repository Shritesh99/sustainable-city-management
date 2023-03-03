package gateway_service

import (
	"context"
	_ "encoding/json"
	"fmt"
	_ "net/http"
	"strings"
	"time"

	db "github.com/Eytins/sustainable-city-management/backend/internal/db/sqlc"
	"github.com/Eytins/sustainable-city-management/backend/internal/util"
	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
)

var jwtKey = []byte("tasty_kimchi")

type AirDataRequest struct {
	StationID string `json:"station_id"`
}

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

type RoleStruct struct {
	RoleID   int32    `json:"role_id"`
	RoleName string   `json:"role_name"`
	Auths    []string `json:"auths"`
}

type Claims struct {
	Username string `json:"username"`
	jwt.RegisteredClaims
}

func (server *GatewayService) Register(c *fiber.Ctx) error {
	req := new(RegisterRequest)
	if err := c.BodyParser(req); err != nil {
		server.log.Infof("Failed to parse body: %v", err)
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
		server.log.Infof("Internal Server Error :  %v", err)
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
	req := new(LoginRequest)
	// Get the JSON body and decode into LoginRequest
	if err := c.BodyParser(req); err != nil {
		server.log.Infof("Failed to parse body: %v", err)
	}
	arg := db.CreateLoginDetailParams{
		Email:    req.Username,
		Password: req.Password,
	}

	loginDetails, err := server.store.GetLoginDetail(context.Background(), arg.Email)
	if err != nil {
		server.log.Infof("Email not registered %v", err)
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

	expirationTime := time.Now().Add(5 * time.Hour)
	claims := &Claims{
		Username: req.Username,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(expirationTime),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString(jwtKey)
	if err != nil {
		server.log.Infof("Error while creating token : %v", err)
		return c.Status(fiber.StatusFailedDependency).JSON(fiber.Map{
			"error": true,
			"msg":   "Error while creating token",
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
		"expires":   expirationTime.Unix(),
		"Token":     tokenString,
	})
}

func (server *GatewayService) GetProfile(c *fiber.Ctx) error {

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
		server.log.Infof("Failed to parse body: %v", err)
	}

	arg := db.CreateLoginDetailParams{
		Email: req.Username,
	}

	loginDetails, err := server.store.GetLoginDetail(context.Background(), arg.Email)
	if err != nil {
		server.log.Infof("Email not found: %v", err)
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
		server.log.Infof("Failed to parse body: %v", err)
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
		server.log.Infof("Failed to parse body: %v", err)
	}

	arg := db.CreateLoginDetailParams{
		Email:    req.Email,
		Password: req.Password,
	}

	loginDetails, err := server.store.GetLoginDetail(context.Background(), arg.Email)
	if err != nil {
		server.log.Infof("Email not registered: %v", err)
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

func (server *GatewayService) GetAirData(c *fiber.Ctx) error {
	tknStr := c.Get("Token")
	var authorization = server.Authenticate(tknStr)
	if !authorization {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"error": true,
			"msg":   "Invalid Token",
			"user":  nil,
		})
	}
	stationId := c.Query("id")
	server.log.Infof("station id : %s", stationId)
	aqi, err := server.store.GetAirDataByStationId(context.Background(), stationId)
	if err != nil {
		server.log.Infof("Error fetching air data: %v", err)
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": err,
			"msg":   "Data not found",
		})
	}

	return c.JSON(fiber.Map{
		"aqi_data": aqi,
		"error":    false,
		"msg":      "success",
	})
}

func (server *GatewayService) GetAQI(c *fiber.Ctx) error {
	airdata, err := server.store.GetAQI(context.Background())
	if err != nil {
		server.log.Infof("Error fetching roles: %v", err)
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": err,
			"msg":   "Data not found",
		})
	}

	return c.JSON(fiber.Map{
		"data":  airdata,
		"error": false,
		"msg":   "success",
	})
}

func (server *GatewayService) GetRoles(c *fiber.Ctx) error {
	roles, err := server.store.GetRoles(context.Background())
	if err != nil {
		server.log.Infof("Error fetching roles: %v", err)
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": err,
			"msg":   "Data not found",
		})
	}

	var res []RoleStruct

	for _, role := range roles {
		auths := strings.Split(role.Auths, ";")
		res = append(res, RoleStruct{
			RoleID:   role.RoleID,
			RoleName: role.RoleName,
			Auths:    auths,
		})
	}

	return c.JSON(fiber.Map{
		"roles_data": res,
		"error":      false,
		"msg":        "success",
	})
}
