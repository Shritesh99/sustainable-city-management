-- name: CreatePedestrian :one
INSERT INTO pedestrian_data (id,
                             street_name,
                             latitude,
                             longitude,
                             time,
                             amount)
VALUES ($1, $2, $3, $4, $5, $6) RETURNING *;

-- name: GetPedestrianByCurrentTime :many
SELECT *
FROM pedestrian_data
WHERE time = $1;

-- name: DeletePedestrian :exec
DELETE
FROM pedestrian_data
WHERE id = $1;