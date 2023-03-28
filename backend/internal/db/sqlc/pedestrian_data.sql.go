// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.17.0
// source: pedestrian_data.sql

package db

import (
	"context"
	"time"
)

const createPedestrian = `-- name: CreatePedestrian :one
INSERT INTO pedestrian_data (location_name,
                             total,
                             longitude,
                             latitude,
                             counter_time,
                             insert_time,
                             update_time)
VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id, location_name, total, longitude, latitude, counter_time, insert_time, update_time
`

type CreatePedestrianParams struct {
	LocationName string    `json:"location_name"`
	Total        int32     `json:"total"`
	Longitude    float64   `json:"longitude"`
	Latitude     float64   `json:"latitude"`
	CounterTime  time.Time `json:"counter_time"`
	InsertTime   time.Time `json:"insert_time"`
	UpdateTime   time.Time `json:"update_time"`
}

func (q *Queries) CreatePedestrian(ctx context.Context, arg CreatePedestrianParams) (PedestrianDatum, error) {
	row := q.db.QueryRowContext(ctx, createPedestrian,
		arg.LocationName,
		arg.Total,
		arg.Longitude,
		arg.Latitude,
		arg.CounterTime,
		arg.InsertTime,
		arg.UpdateTime,
	)
	var i PedestrianDatum
	err := row.Scan(
		&i.ID,
		&i.LocationName,
		&i.Total,
		&i.Longitude,
		&i.Latitude,
		&i.CounterTime,
		&i.InsertTime,
		&i.UpdateTime,
	)
	return i, err
}

const deletePedestrian = `-- name: DeletePedestrian :exec
DELETE
FROM pedestrian_data
WHERE id = $1
`

func (q *Queries) DeletePedestrian(ctx context.Context, id int32) error {
	_, err := q.db.ExecContext(ctx, deletePedestrian, id)
	return err
}

const getPedestrianByCurrentTime = `-- name: GetPedestrianByCurrentTime :many
SELECT id, location_name, total, longitude, latitude, counter_time, insert_time, update_time
FROM pedestrian_data
WHERE current_time = $1
`

func (q *Queries) GetPedestrianByCurrentTime(ctx context.Context, dollar_1 interface{}) ([]PedestrianDatum, error) {
	rows, err := q.db.QueryContext(ctx, getPedestrianByCurrentTime, dollar_1)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []PedestrianDatum
	for rows.Next() {
		var i PedestrianDatum
		if err := rows.Scan(
			&i.ID,
			&i.LocationName,
			&i.Total,
			&i.Longitude,
			&i.Latitude,
			&i.CounterTime,
			&i.InsertTime,
			&i.UpdateTime,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}
