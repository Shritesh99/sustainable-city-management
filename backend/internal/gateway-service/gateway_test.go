package gateway_service

import (
	_ "github.com/Eytins/sustainable-city-management/backend/config"
	_ "github.com/Eytins/sustainable-city-management/backend/pkg/logger"
	"github.com/golang-jwt/jwt/v4"
	"github.com/stretchr/testify/assert"
	"net/http"
	"strings"
	"testing"
	"time"
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

func TestGetProfileWithoutToken(t *testing.T) {
	registerBody := `{
        "username": "johasan2doe@example.com"
    }`

	// Iterate through test single test cases

	resp, err := http.Post("http://127.0.0.1:8000/auth/profile", "application/json", strings.NewReader(registerBody))
	if err != nil {
		print(err)
	}
	assert.Nil(t, err)
	assert.Equal(t, http.StatusUnauthorized, resp.StatusCode)
}

func GenerateToken() string {
	expirationTime := time.Now().Add(5 * time.Hour)
	// Create the JWT claims, which includes the username and expiry time
	claims := &Claims{
		Username: "abcde@gmail.com",
		RegisteredClaims: jwt.RegisteredClaims{
			// In JWT, the expiry time is expressed as unix milliseconds
			ExpiresAt: jwt.NewNumericDate(expirationTime),
		},
	}

	// Declare the token with the algorithm used for signing, and the claims
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	// Create the JWT string
	tokenString, _ := token.SignedString(jwtKey)
	return tokenString
	// Finally, we set the client cookie for "token" as the JWT we just generated

}
