-- name: CreatePedestrian :one
INSERT INTO pedestrian_data (location_name,
                             total,
                             longitude,
                             latitude,
                             counter_time,
                             insert_time,
                             update_time)
VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *;

-- name: GetPedestrianByCurrentTime :many
SELECT *
FROM pedestrian_data
WHERE current_time = $1;

-- name: DeletePedestrian :exec
DELETE
FROM pedestrian_data
WHERE id = $1;