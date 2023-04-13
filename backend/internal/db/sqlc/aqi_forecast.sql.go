// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.17.0
// source: aqi_forecast.sql

package db

import (
	"context"
)

const getForecastAirData = `-- name: GetForecastAirData :many
SELECT station_id, forecast_time, aqi, pm25, pm10, ozone, no2, so2, co, latitude, longitude FROM aqi_forecast
`

func (q *Queries) GetForecastAirData(ctx context.Context) ([]AqiForecast, error) {
	rows, err := q.db.QueryContext(ctx, getForecastAirData)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []AqiForecast
	for rows.Next() {
		var i AqiForecast
		if err := rows.Scan(
			&i.StationID,
			&i.ForecastTime,
			&i.Aqi,
			&i.Pm25,
			&i.Pm10,
			&i.Ozone,
			&i.No2,
			&i.So2,
			&i.Co,
			&i.Latitude,
			&i.Longitude,
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
