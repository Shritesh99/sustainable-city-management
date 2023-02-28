-- name: CreateAirData :one
INSERT INTO aqi_data (stationid, air_data)
VALUES ($1, $2) RETURNING *;

-- name: GetAirData :one
SELECT *
FROM aqi_data
WHERE stationid = $1;

-- name: DeleteAirData :exec
DELETE
FROM aqi_data
WHERE stationid = $1;