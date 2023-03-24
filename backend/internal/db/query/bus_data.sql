-- name: CreateBusData :one
INSERT INTO bus_data ("vehicle_id",
                      "latitude",
                      "longitude",
                      "route_id",
                      "direction_id",
                      "detail")
VALUES ($1, $2, $3, $4, $5, $6)
ON CONFLICT(vehicle_id) DO
UPDATE SET "latitude" = $2,
           "longitude" = $3,
           "route_id" = $4,
           "direction_id" = $5,
           "detail" = $6
RETURNING *;

-- name: GetBusDataByRouteId :many
SELECT *
FROM bus_data
WHERE route_id = $1;
