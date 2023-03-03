-- name: CreateAirData :one
INSERT INTO aqi_data ("station_id","station_name","aqi","measure_time","epa","pm25","pm10","ozone","no2","so2","co","insert_time","updated_time","latitude","longitude" )
VALUES ($1, $2,$3, $4,$5, $6,$7, $8,$9, $10,$11, $12,$13,$14,$15) RETURNING *;

-- name: GetAirDataByStationId :one
SELECT * FROM aqi_data WHERE station_id = $1 ORDER BY updated_time DESC LIMIT 1;

-- name: DeleteAirData :exec
DELETE
FROM aqi_data
WHERE station_id = $1;

-- name: GetAQI :many
SELECT station_id,station_name,latitude,longitude,aqi FROM aqi_data ORDER BY updated_time DESC LIMIT 20;