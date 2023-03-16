-- name: CreateNoiseData :one
INSERT INTO noise_data ("monitor_id", "location", "latitude", "longitude", "record_time", "laeq", "current_rating",
                        "daily_avg", "hourly_avg")
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *;

-- name: GetNoiseData :one
SELECT *
FROM noise_data
WHERE monitor_id = $1
ORDER BY record_time DESC LIMIT 1;

-- name: DeleteNoiseData :exec
DELETE
FROM noise_data
WHERE monitor_id = $1;
