-- name: CreateBikeData :one
INSERT INTO bike_data ("id",
                       "contract_name",
                       "name",
                       "address",
                       "latitude",
                       "longitude",
                       "status",
                       "last_update",
                       "bikes",
                       "stands",
                       "mechanical_bikes",
                       "electrical_bikes")
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12) ON CONFLICT(id) DO
UPDATE
    SET "id" = $1,
    "contract_name" = $2,
    "name" = $3,
    "address" = $4,
    "latitude" = $5,
    "longitude" = $6,
    "status" = $7,
    "last_update" = $8,
    "bikes" = $9,
    "stands" = $10,
    "mechanical_bikes" = $11,
    "electrical_bikes" = $12
RETURNING *;

-- name: GetAllBikeData :many
SELECT *
FROM bike_data;
