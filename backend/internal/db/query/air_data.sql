-- name: CreateAirData :one
INSERT INTO aqi_data ("station_id","station_name","aqi","measure_time","pm25","pm10","ozone","no2","so2","co","insert_time","updated_time" )
VALUES ($1, $2,$3, $4,$5, $6,$7, $8,$9, $10,$11, $12) RETURNING *;

-- name: GetAirData :one
SELECT *
FROM aqi_data
WHERE id = $1;

-- name: DeleteAirData :exec
DELETE
FROM aqi_data
WHERE id = $1;