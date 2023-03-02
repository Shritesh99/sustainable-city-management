package gateway_service

import (
	"context"
	db "github.com/Eytins/sustainable-city-management/backend/internal/db/sqlc"
	"log"
	"time"
	// "github.com/Eytins/sustainable-city-management/backend/internal/util"
)

func (server *GatewayService) CollectStationData() error {
	stationIds := []string{"@13372", "@5112", "@13402", "@14650", "@14649", "@14651", "@14648", "@13412", "@13378", "@13405", "@13377", "@14765", "@14771", "@13379", "@13384", "@13404", "@13376", "@13374", "@13400", "@13363"}
	for _, v := range stationIds {
		resp := server.CollectAirStationData(v)
		arg := db.CreateAirDataParams{
			StationID:   v,
			StationName: string(resp.Data.City.Name),
			Aqi:         float64(resp.Data.Aqi),
			MeasureTime: resp.Data.Time.S,
			Pm25:        float64(resp.Data.Iaqi.Pm25.V),
			Pm10:        float64(resp.Data.Iaqi.Pm10.V),
			Ozone:       resp.Data.Iaqi.O3.V,
			No2:         resp.Data.Iaqi.No2.V,
			So2:         resp.Data.Iaqi.So2.V,
			Co:          float64(resp.Data.Iaqi.Co.V),
			InsertTime:  time.Now(),
			UpdatedTime: time.Now(),
		}
		_, err := server.store.CreateAirData(context.Background(), arg)
		if err != nil {
			log.Fatal(err)
		}
	}
	return nil
}
