// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.17.0
// source: air_data.sql

package db

import (
	"context"
	"time"
)

const createAirData = `-- name: CreateAirData :one
INSERT INTO aqi_data ("station_id","station_name","aqi","measure_time","epa","pm25","pm10","ozone","no2","so2","co","insert_time","updated_time","latitude","longitude" )
VALUES ($1, $2,$3, $4,$5, $6,$7, $8,$9, $10,$11, $12,$13,$14,$15) RETURNING id, station_id, station_name, aqi, measure_time, epa, pm25, pm10, ozone, no2, so2, co, insert_time, updated_time, latitude, longitude
`

type CreateAirDataParams struct {
	StationID   string    `json:"station_id"`
	StationName string    `json:"station_name"`
	Aqi         float64   `json:"aqi"`
	MeasureTime string    `json:"measure_time"`
	Epa         string    `json:"epa"`
	Pm25        float64   `json:"pm25"`
	Pm10        float64   `json:"pm10"`
	Ozone       float64   `json:"ozone"`
	No2         float64   `json:"no2"`
	So2         float64   `json:"so2"`
	Co          float64   `json:"co"`
	InsertTime  time.Time `json:"insert_time"`
	UpdatedTime time.Time `json:"updated_time"`
	Latitude    float64   `json:"latitude"`
	Longitude   float64   `json:"longitude"`
}

func (q *Queries) CreateAirData(ctx context.Context, arg CreateAirDataParams) (AqiDatum, error) {
	row := q.db.QueryRowContext(ctx, createAirData,
		arg.StationID,
		arg.StationName,
		arg.Aqi,
		arg.MeasureTime,
		arg.Epa,
		arg.Pm25,
		arg.Pm10,
		arg.Ozone,
		arg.No2,
		arg.So2,
		arg.Co,
		arg.InsertTime,
		arg.UpdatedTime,
		arg.Latitude,
		arg.Longitude,
	)
	var i AqiDatum
	err := row.Scan(
		&i.ID,
		&i.StationID,
		&i.StationName,
		&i.Aqi,
		&i.MeasureTime,
		&i.Epa,
		&i.Pm25,
		&i.Pm10,
		&i.Ozone,
		&i.No2,
		&i.So2,
		&i.Co,
		&i.InsertTime,
		&i.UpdatedTime,
		&i.Latitude,
		&i.Longitude,
	)
	return i, err
}

const deleteAirData = `-- name: DeleteAirData :exec
DELETE
FROM aqi_data
WHERE station_id = $1
`

func (q *Queries) DeleteAirData(ctx context.Context, stationID string) error {
	_, err := q.db.ExecContext(ctx, deleteAirData, stationID)
	return err
}

const getAQI = `-- name: GetAQI :many
SELECT station_id,station_name,latitude,longitude,aqi FROM aqi_data ORDER BY updated_time DESC LIMIT 20
`

type GetAQIRow struct {
	StationID   string  `json:"station_id"`
	StationName string  `json:"station_name"`
	Latitude    float64 `json:"latitude"`
	Longitude   float64 `json:"longitude"`
	Aqi         float64 `json:"aqi"`
}

func (q *Queries) GetAQI(ctx context.Context) ([]GetAQIRow, error) {
	rows, err := q.db.QueryContext(ctx, getAQI)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetAQIRow
	for rows.Next() {
		var i GetAQIRow
		if err := rows.Scan(
			&i.StationID,
			&i.StationName,
			&i.Latitude,
			&i.Longitude,
			&i.Aqi,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const getAirDataByStationId = `-- name: GetAirDataByStationId :one
SELECT id, station_id, station_name, aqi, measure_time, epa, pm25, pm10, ozone, no2, so2, co, insert_time, updated_time, latitude, longitude FROM aqi_data WHERE station_id = $1 ORDER BY updated_time DESC LIMIT 1
`

func (q *Queries) GetAirDataByStationId(ctx context.Context, stationID string) (AqiDatum, error) {
	row := q.db.QueryRowContext(ctx, getAirDataByStationId, stationID)
	var i AqiDatum
	err := row.Scan(
		&i.ID,
		&i.StationID,
		&i.StationName,
		&i.Aqi,
		&i.MeasureTime,
		&i.Epa,
		&i.Pm25,
		&i.Pm10,
		&i.Ozone,
		&i.No2,
		&i.So2,
		&i.Co,
		&i.InsertTime,
		&i.UpdatedTime,
		&i.Latitude,
		&i.Longitude,
	)
	return i, err
}
