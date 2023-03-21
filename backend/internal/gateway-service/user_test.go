package gateway_service

import (
	_ "github.com/Eytins/sustainable-city-management/backend/config"
	_ "github.com/Eytins/sustainable-city-management/backend/pkg/logger"
	"github.com/stretchr/testify/assert"
	"net/http"
	"strings"
	"testing"
)

func TestRegisterValidRequest(t *testing.T) {
	registerBody := `{
        "firstName": "aJohn",
        "lastName": "aDoe",
        "username": "johasan2doe@example.com",
        "password": "passsord1233",
        "roleID": 1
    }`
	resp, err := http.Post("http://127.0.0.1:8000/auth/register", "application/json", strings.NewReader(registerBody))
	if err != nil {
		print(err)
	}
	assert.Nil(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func TestRegisterForExistingEmail(t *testing.T) {
	registerBody := `{
        "firstName": "aJohn",
        "lastName": "aDoe",
        "username": "johasan2doe@example.com",
        "password": "passsord1233",
        "roleID": 1
    }`
	resp, err := http.Post("http://127.0.0.1:8000/auth/register", "application/json", strings.NewReader(registerBody))
	if err != nil {
		print(err)
	}
	assert.Nil(t, err)
	assert.Equal(t, http.StatusBadRequest, resp.StatusCode)
}

func TestRegisterForInvalidJSON(t *testing.T) {
	registerBody := `{
    invalid
    }`
	resp, err := http.Post("http://127.0.0.1:8000/auth/register", "application/json", strings.NewReader(registerBody))
	if err != nil {
		print(err)
	}
	assert.Nil(t, err)
	assert.Equal(t, http.StatusBadRequest, resp.StatusCode)
}

func TestLoginRequest(t *testing.T) {
	registerBody := `{
        "username": "johasan2doe@example.com",
        "password": "passsord1233"
    }`
	resp, err := http.Post("http://127.0.0.1:8000/auth/login", "application/json", strings.NewReader(registerBody))
	if err != nil {
		print(err)
	}
	assert.Nil(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func TestLoginRequestRegisteredEmail(t *testing.T) {
	registerBody := `{
        "username": "johasssan2doe@example.com",
        "password": "passsord1233"
    }`
	resp, err := http.Post("http://127.0.0.1:8000/auth/login", "application/json", strings.NewReader(registerBody))
	if err != nil {
		print(err)
	}
	assert.Nil(t, err)
	assert.Equal(t, http.StatusUnauthorized, resp.StatusCode)
}

func TestLoginRequestWrongPassword(t *testing.T) {
	registerBody := `{
        "username": "johasan2doe@example.com",
        "password": "passsorsd1233"
    }`
	resp, err := http.Post("http://127.0.0.1:8000/auth/login", "application/json", strings.NewReader(registerBody))
	if err != nil {
		print(err)
	}
	assert.Nil(t, err)
	assert.Equal(t, http.StatusUnauthorized, resp.StatusCode)
}
