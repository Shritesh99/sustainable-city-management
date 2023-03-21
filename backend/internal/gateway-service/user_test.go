package gateway_service

import (
	"context"
	"database/sql"
	_ "github.com/Eytins/sustainable-city-management/backend/config"
	db "github.com/Eytins/sustainable-city-management/backend/internal/db/sqlc"
	_ "github.com/Eytins/sustainable-city-management/backend/pkg/logger"
	"github.com/gofiber/fiber/v2"
	"github.com/stretchr/testify/assert"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestRegisterValidRequest(t *testing.T) {
	registerBody := `{
        "firstName": "John",
        "lastName": "Doe",
        "username": "john2doe@example.com",
        "password": "password1233",
        "roleID": 1
    }`
	resp, err := http.Post("/register", "application/json", strings.NewReader(registerBody))
	if err != nil {
		print(err)
	}
	print(resp.Body)
	//assert.Nil(t, err)
	//assert.Equal(t, http.StatusOK, resp.StatusCode)
}

type mockStore struct{}

func (m *mockStore) GetLoginDetail(ctx context.Context, email string) (*db.LoginDetail, error) {
	return nil, sql.ErrNoRows
}

func (m *mockStore) CreateUser(ctx context.Context, arg db.CreateUserParams) (*db.User, error) {
	return &db.User{UserID: 1}, nil
}

func (m *mockStore) CreateLoginDetail(ctx context.Context, arg db.CreateLoginDetailParams) (*db.LoginDetail, error) {
	return &db.LoginDetail{Email: arg.Email}, nil
}

func TestRegisterErrorParsingRequestBody(t *testing.T) {
	app := fiber.New()
	registerBody := `{
        "firstName": "John",
        "lastName": "Doe",
        "username": "johndsoe@example.com",
        "password": "password123",
        "roleID": 1
    }`
	req := httptest.NewRequest(http.MethodPost, "/register", strings.NewReader(registerBody))
	req.Header.Set("Content-Type", "application/json")
	resp, err := app.Test(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusBadRequest, resp.StatusCode)
}

func TestRegisterExistingEmailAddress(t *testing.T) {
	app := fiber.New()
	//	store := &mockStore{}
	//	server := &GatewayService{store: store}
	registerBody := `{
        "firstName": "John",
        "lastName": "Doe",
        "username": "johndoe@example.com",
        "password": "password123",
        "roleID": 1
    }`
	req := httptest.NewRequest(http.MethodPost, "/register", strings.NewReader(registerBody))
	req.Header.Set("Content-Type", "application/json")
	resp, err := app.Test(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusBadRequest, resp.StatusCode)
}

func TestRegisterErrorCreatingUser(t *testing.T) {
	app := fiber.New()
	//store := &mockStore{}
	//server := &GatewayService{store: store}
	registerBody := `{
        "firstName": "John",
        "lastName": "Doe",
        "username": "johndoe@example.com",
        "password": "password123",
        "roleID": 1
    }`
	req := httptest.NewRequest(http.MethodPost, "/register", strings.NewReader(registerBody))
	req.Header.Set("Content-Type", "application/json")
	resp, err := app.Test(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusInternalServerError, resp.StatusCode)
}

func TestRegisterErrorCreatingLoginDetail(t *testing.T) {
	app := fiber.New()
	//store := &mockStore{}
	//server := &GatewayService{store: store}
	registerBody := `{
        "firstName": "John",
        "lastName": "Doe",
        "username": "johndoe@example.com",
        "password": "password123",
        "roleID": 1
    }`
	req := httptest.NewRequest(http.MethodPost, "/register", strings.NewReader(registerBody))
	req.Header.Set("Content-Type", "application/json")
	resp, err := app.Test(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusInternalServerError, resp.StatusCode)
}
