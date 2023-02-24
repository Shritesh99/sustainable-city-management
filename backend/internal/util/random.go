package util

import (
	"math/rand"
	"strings"
	"time"
)

const alphabet string = "abcdefghijklmnopqrstuvwxyz"

func init() {
	rand.Seed(time.Now().UnixNano())
}

// generates a random string of length n
func randomString(n int) string {
	var sb strings.Builder
	keyLen := len(alphabet)

	for i := 0; i < n; i ++ {
		c := alphabet[rand.Intn(keyLen)]
		sb.WriteByte(c)
	}

	return sb.String()
}

// return random name for testing
func RandomName() string {
	return randomString(6)
}

// role enum
type RoleEnum int

const (
	Admin RoleEnum = iota
	CityManager
	ServiceProvider
)

func (r RoleEnum) randomRoleString() string {
	switch r {
	case Admin:
		return "Admin"
	case CityManager:
		return "City Manager"
	case ServiceProvider:
		return "Service Provider"
	default:
		return "Admin"		
	}
}

// generate random role for testing
func RandomRole() string {
	return RoleEnum(rand.Intn(3)).randomRoleString()
}


// generate random email for testing
func RandomEmail() string {
	strSlice := []string{randomString(5), "@", randomString(4), ".com"}
	return strings.Join(strSlice, "");
}

// generate random password for testing
func RandomPwd() string {
	return randomString(10);
}