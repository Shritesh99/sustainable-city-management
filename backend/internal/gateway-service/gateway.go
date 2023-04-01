package gateway_service

import (
	"context"
	_ "encoding/json"
	"fmt"
	_ "net/http"
	"strings"
	"time"

	pb_air "github.com/Eytins/sustainable-city-management/backend/pb/air-quality/air-pd"
	pb_bike "github.com/Eytins/sustainable-city-management/backend/pb/bike/bike-pd"
	pb_bin "github.com/Eytins/sustainable-city-management/backend/pb/bin/bin-pd"
	pb_bus "github.com/Eytins/sustainable-city-management/backend/pb/bus/bus-pd"
	"golang.org/x/crypto/bcrypt"

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

// LoginRequest Create a struct to read the username and password from the request body
type LoginRequest struct {
	Password string `json:"password"`
	Username string `json:"username"`
}

// LogoutRequest Create a struct to read the username
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

func validateUser(c *fiber.Ctx, server *GatewayService) (error, bool) {
	tknStr := c.GetReqHeaders()["Token"]
	var authorization = server.Authenticate(tknStr)
	if !authorization {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"error": true,
			"msg":   "Invalid Token",
			"user":  nil,
		}), true
	}
	return nil, false
}

func (server *GatewayService) Register(c *fiber.Ctx) error {
	req := new(RegisterRequest)
	if err := c.BodyParser(req); err != nil {
		server.log.Infof("Failed to parse body: %v", err)
	}

	encryptedPwd, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)

	argCheck := db.CreateLoginDetailParams{
		Email:    req.Username,
		Password: string(encryptedPwd),
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
		fmt.Printf("[CreateUser] %s\n", err)
		return c.Status(fiber.StatusFailedDependency).JSON(fiber.Map{
			"error": true,
			"msg":   "User could not be created",
		})
	}

	argLogin := db.CreateLoginDetailParams{
		RoleID:   req.RoleID,
		UserID:   user.UserID,
		Email:    req.Username,
		Password: string(encryptedPwd),
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
		"email":  loginDetails.Email,
	})
}

// Login Create the Sign in handler
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

	err = bcrypt.CompareHashAndPassword([]byte(loginDetails.Password), []byte(req.Password))
	if err != nil {
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
	err, done := validateUser(c, server)
	if done {
		return err
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
	if err != nil {
		server.log.Infof("User not found: %v", err)
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": true,
			"msg":   "User not found",
		})
	}
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
	req := new(LogoutRequest)
	// Get the JSON body and decode into LogoutRequest
	if err := c.BodyParser(req); err != nil {
		server.log.Infof("Failed to parse body: %v", err)
	}
	fmt.Printf("[Logout] username: %s\n", req.Username)
	err, done := validateUser(c, server)
	if done {
		return err
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

func (server *GatewayService) GetAirStation(c *fiber.Ctx) error {
	err, done := validateUser(c, server)
	if done {
		return err
	}
	stationId := c.Query("id")
	client := pb_air.NewAirServiceClient(server.airClientConn)
	resp, err := client.GetAirStation(context.Background(), &pb_air.AirIdRequest{StationId: stationId})
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err,
			"msg":   "Data not found",
		})
	}

	return c.JSON(fiber.Map{
		"aqi_data": resp,
		"error":    false,
		"msg":      "success",
	})
}

func (server *GatewayService) GetDetailedAirData(c *fiber.Ctx) error {
	err, done := validateUser(c, server)
	if done {
		return err
	}
	client := pb_air.NewAirServiceClient(server.airClientConn)
	req := pb_air.NilRequest{}
	resp, err := client.GetDetailedAirData(context.Background(), &req)
	if err != nil {
		server.log.Infof("Error fetching GetServiceClient: %v", err)
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err,
			"msg":   "Data not found",
		})
	}
	return c.JSON(fiber.Map{
		"aqi_data": resp,
		"error":    false,
		"msg":      "success",
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

func (server *GatewayService) GetNoiseData(c *fiber.Ctx) error {
	err, done := validateUser(c, server)
	if done {
		return err
	}
	client := pb_air.NewAirServiceClient(server.airClientConn)
	resp, err := client.GetNoiseData(context.Background(), &pb_air.NilRequest{})
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err,
			"msg":   "Data not found",
		})
	}
	return c.JSON(fiber.Map{
		"noise_data": resp,
		"error":      false,
		"msg":        "success",
	})
}

func (server *GatewayService) GetBusDataByRouteId(c *fiber.Ctx) error {
	err, done := validateUser(c, server)
	if done {
		return err
	}
	client := pb_bus.NewBusServiceClient(server.busClientConn)
	req := pb_bus.RouteIdRequest{Id: c.Query("id")}
	resp, err := client.GetBusDataByRouteId(context.Background(), &req)
	if err != nil {
		return c.Status(fiber.StatusNoContent).JSON(fiber.Map{
			"error": err,
			"msg":   "Data not found",
		})
	}
	return c.JSON(fiber.Map{
		"bus_data": resp,
		"error":    false,
		"msg":      "success",
	})
}

func (server *GatewayService) GetBikes(c *fiber.Ctx) error {
	err, done := validateUser(c, server)
	if done {
		return err
	}
	client := pb_bike.NewBikeServiceClient(server.bikeClientConn)
	req := pb_bike.GetBikesRequest{}
	resp, err := client.GetBikes(context.Background(), &req)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err,
			"msg":   "Data not found",
		})
	}
	return c.JSON(fiber.Map{
		"bike_data": resp,
		"error":     false,
		"msg":       "success",
	})
}

func (server *GatewayService) GetAllBins(c *fiber.Ctx) error {
	err, done := validateUser(c, server)
	if done {
		return err
	}
	client := pb_bin.NewBinServiceClient(server.binClientConn)
	req := pb_bin.GetAllBinsRequest{}
	resp, err := client.GetAllBins(context.Background(), &req)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err,
			"msg":   "Data not found",
		})
	}
	return c.JSON(fiber.Map{
		"bin_data": resp,
		"error":    false,
		"msg":      "success",
	})
}

func (server *GatewayService) GetBinsByRegion(c *fiber.Ctx) error {
	err, done := validateUser(c, server)
	if done {
		return err
	}
	client := pb_bin.NewBinServiceClient(server.binClientConn)
	req := pb_bin.GetBinsByRegionRequest{Region: int32(c.QueryInt("region"))}
	resp, err := client.GetBinsByRegion(context.Background(), &req)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err,
			"msg":   "Data not found",
		})
	}
	return c.JSON(fiber.Map{
		"bin_data": resp,
		"error":    false,
		"msg":      "success",
	})
}

func (server *GatewayService) GetPedestrianDataByTime(c *fiber.Ctx) error {
	err, done := validateUser(c, server)
	if done {
		return err
	}
	client := pb_air.NewAirServiceClient(server.airClientConn)
	req := pb_air.TimeRequest{Time: int64(c.QueryInt("time"))}
	resp, err := client.GetPedestrianDataByTime(context.Background(), &req)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
			"msg":   "Data not found",
		})
	}
	return c.JSON(fiber.Map{
		"pedestrian_data": resp,
		"error":           false,
		"msg":             "success",
	})
}
