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
        "first_name": "test1",
        "last_name": "user",
        "username": "abcdef@gmail.com",
        "password": "pwd123",
        "roleID": 0
    }`
	resp, err := http.Post("http://127.0.0.1:8000/gateway/register", "application/json", strings.NewReader(registerBody))
	if err != nil {
		print(err)
	}
	assert.Nil(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func TestRegisterForExistingEmail(t *testing.T) {
	registerBody := `{
        "first_name": "aJohn",
        "last_name": "aDoe",
        "username": "johasan2doe@example.com",
        "password": "passsord1233",
        "roleID": 1
    }`
	resp, err := http.Post("http://127.0.0.1:8000/gateway/register", "application/json", strings.NewReader(registerBody))
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
	resp, err := http.Post("http://127.0.0.1:8000/gateway/register", "application/json", strings.NewReader(registerBody))
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
	resp, err := http.Post("http://127.0.0.1:8000/gateway/login", "application/json", strings.NewReader(registerBody))
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
	resp, err := http.Post("http://127.0.0.1:8000/gateway/login", "application/json", strings.NewReader(registerBody))
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
	resp, err := http.Post("http://127.0.0.1:8000/gateway/login", "application/json", strings.NewReader(registerBody))
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

	resp, err := http.Post("http://127.0.0.1:8000/gateway/profile", "application/json", strings.NewReader(registerBody))
	if err != nil {
		print(err)
	}
	assert.Nil(t, err)
	assert.Equal(t, http.StatusUnauthorized, resp.StatusCode)
}

func TestGetProfileWithToken(t *testing.T) {
	var token = GenerateToken()
	registerBody := `{
        "username": "abcdef@gmail.com"
    }`

	// Iterate through test single test cases
	req, err := http.NewRequest("POST", "http://127.0.0.1:8000/gateway/profile", strings.NewReader(registerBody))
	if err != nil {
		return
	}
	req.Header.Set("Token", token)
	req.Header.Set("Content-Type", "application/json")
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return
	}
	assert.Nil(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func TestGatewayService_GetRoles(t *testing.T) {
	resp, err := http.Get("http://127.0.0.1:8000/gateway/getRoles")
	if err != nil {
		print(err)
	}
	assert.Nil(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func TestGatewayService_GetAirStations(t *testing.T) {
	var token = GenerateToken()

	req, err := http.NewRequest("GET", "http://127.0.0.1:8000/gateway/getAirStation?id=@13372", nil)
	if err != nil {
		return
	}
	req.Header.Set("Token", token)
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return
	}
	assert.Nil(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func TestGatewayService_GetDetailedAirData(t *testing.T) {
	var token = GenerateToken()
	req, err := http.NewRequest("GET", "http://127.0.0.1:8000/gateway/getDetailedAirData", nil)
	if err != nil {
		return
	}
	req.Header.Set("Token", token)
	req.Header.Set("Content-Type", "application/json")
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return
	}
	assert.Nil(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func TestGatewayService_GetNoiseData(t *testing.T) {
	var token = GenerateToken()
	req, err := http.NewRequest("GET", "http://127.0.0.1:8000/gateway/getNoiseData", nil)
	req.Header.Set("Token", token)
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return
	}
	assert.Nil(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func TestGatewayService_GetBusDataByRouteId(t *testing.T) {
	var token = GenerateToken()
	req, err := http.NewRequest("GET", "http://127.0.0.1:8000/gateway/getBusDataByRouteId?id=2961_46101", nil)
	req.Header.Set("Token", token)
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return
	}
	assert.Nil(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func TestGatewayService_GetBikes(t *testing.T) {
	var token = GenerateToken()
	req, err := http.NewRequest("GET", "http://127.0.0.1:8000/gateway/getBikes", nil)
	req.Header.Set("Token", token)
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return
	}
	assert.Nil(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func TestGatewayService_GetAllBins(t *testing.T) {
	var token = GenerateToken()
	req, err := http.NewRequest("GET", "http://127.0.0.1:8000/gateway/getAllBins", nil)
	req.Header.Set("Token", token)
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return
	}
	assert.Nil(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func TestGatewayService_GetBinsByRegion(t *testing.T) {
	var token = GenerateToken()
	req, err := http.NewRequest("GET", "http://127.0.0.1:8000/gateway/getBinsByRegion", nil)
	req.Header.Set("Token", token)
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return
	}
	assert.Nil(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func TestGatewayService_GetPedestrianDataByTime(t *testing.T) {
	var token = GenerateToken()
	req, err := http.NewRequest("GET", "http://http://127.0.0.1:8000/gateway/getPedestrianByTime?time=1680361200", nil)
	req.Header.Set("Token", token)
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return
	}
	assert.Nil(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func TestGatewayService_GetPredictedAirStations(t *testing.T) {
	var token = GenerateToken()
	req, err := http.NewRequest("GET", "http://127.0.0.1:8000/gateway/getPredictedAirStations", nil)
	req.Header.Set("Token", token)
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return
	}
	assert.Nil(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func TestGatewayService_GetPredictedDetailedAirData(t *testing.T) {
	var token = GenerateToken()
	req, err := http.NewRequest("GET", "http://127.0.0.1:8000/gateway/getPredictedDetailedAirData?id=@14771", nil)
	req.Header.Set("Token", token)
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return
	}
	assert.Nil(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func GenerateToken() string {
	expirationTime := time.Now().Add(5 * time.Hour)
	// Create the JWT claims, which includes the username and expiry time
	claims := &Claims{
		Username: "abcd@gmail.com",
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
