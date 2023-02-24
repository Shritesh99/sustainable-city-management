-- name: CreateAirData :one
INSERT INTO air_data (long,
                      lati,
                      timestamp,
                      detail)
VALUES ($1, $2, $3, $4) RETURNING *;

-- name: GetAirData :one
SELECT *
FROM air_data
WHERE long = $1
  and lati = $2;

-- name: DeleteAirData :exec
DELETE
FROM air_data
WHERE long = $1
  and lati = $2
  and timestamp = $3;