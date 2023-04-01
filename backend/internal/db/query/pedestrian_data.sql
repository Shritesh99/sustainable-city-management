-- name: CreatePedestrian :one
INSERT INTO pedestrian_data (street_name,
                             latitude,
                             longitude,
                             time,
                             amount)
VALUES ($1, $2, $3, $4, $5) RETURNING *;

-- name: GetPedestrianByTime :many
SELECT *
FROM pedestrian_data
WHERE time = $1;

-- name: DeletePedestrian :exec
DELETE
FROM pedestrian_data
WHERE id = $1;

-- name: GetFirstPedestrianIdsOfOneDay :many
SELECT id
FROM pedestrian_data
ORDER BY id ASC
LIMIT 552;
