package gateway_service

import (
	"context"
	db "github.com/Eytins/sustainable-city-management/backend/internal/db/sqlc"
	"log"
)

func (server *GatewayService) SaveNoiseData() error {
	resp := server.CollectNoiseData()
	for _, data := range resp {
		arg := db.CreateNoiseDataParams{
			MonitorID:     int32(data.MonitorId),
			Location:      data.Location,
			Latitude:      data.Latitude,
			Longitude:     data.Longitude,
			RecordTime:    data.LatestReading.RecordedAt,
			Laeq:          data.LatestReading.Laeq,
			CurrentRating: int32(data.CurrentRating),
			DailyAvg:      data.LatestAverage.Value,
			HourlyAvg:     data.LatestHourlyAverage.Value,
		}
		_, err := server.store.CreateNoiseData(context.Background(), arg)
		if err != nil {
			log.Fatal(err)
		}
	}
	return nil
}
