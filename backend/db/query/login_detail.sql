-- name: CreateLoginDetail :one
INSERT INTO login_details (
    role_id,
    user_id,
    email,
    password
) VALUES (
    $1, $2, $3, $4
) RETURNING *;

-- name: GetLoginDetail :one
SELECT * FROM login_details
WHERE email = $1 LIMIT 1;

-- name: UpdateLoginDetail :one
UPDATE login_details
SET email = $2
WHERE email = $1
RETURNING *;

-- DeleteLoginDetail :exec
DELETE FROM login_details
WHERE email = $1;