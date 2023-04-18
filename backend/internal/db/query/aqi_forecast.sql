-- name: GetForecastAirData :many
SELECT * FROM aqi_forecast;

-- name: GetPredictedAirDataByStationId :one
SELECT * FROM aqi_forecast WHERE station_id = $1 LIMIT 1;
