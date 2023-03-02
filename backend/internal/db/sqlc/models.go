// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.17.0

package db

import (
	"time"
)

type AqiDatum struct {
	ID          int32     `json:"id"`
	StationID   string    `json:"station_id"`
	StationName string    `json:"station_name"`
	Aqi         float64   `json:"aqi"`
	MeasureTime string    `json:"measure_time"`
	Pm25        float64   `json:"pm25"`
	Pm10        float64   `json:"pm10"`
	Ozone       float64   `json:"ozone"`
	No2         float64   `json:"no2"`
	So2         float64   `json:"so2"`
	Co          float64   `json:"co"`
	InsertTime  time.Time `json:"insert_time"`
	UpdatedTime time.Time `json:"updated_time"`
}

type LoginDetail struct {
	RoleID   int32  `json:"role_id"`
	UserID   int32  `json:"user_id"`
	Email    string `json:"email"`
	Password string `json:"password"`
}

type Role struct {
	RoleID   int32  `json:"role_id"`
	RoleName string `json:"role_name"`
	Auths    string `json:"auths"`
}

type User struct {
	UserID    int32  `json:"user_id"`
	FirstName string `json:"first_name"`
	LastName  string `json:"last_name"`
}
