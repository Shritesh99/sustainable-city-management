-- name: CreateBinData :one
INSERT INTO bin_data ("id",
                      "latitude",
                      "longitude",
                      "region",
                      "status")
VALUES ($1, $2, $3, $4, $5) RETURNING *;

-- name: GetAllBinData :many
SELECT *
FROM bin_data;

-- name: GetBinDataByRegion :many
SELECT *
FROM bin_data
WHERE region = $1;

-- name: GetBinIds :many
SELECT id
FROM bin_data;

-- name: ChangeBinDataStatus :exec
UPDATE bin_data
SET status = $2
WHERE id = $1;