package gateway_service

import (
	"context"
	db "github.com/Eytins/sustainable-city-management/backend/internal/db/sqlc"
	"log"
	// "github.com/Eytins/sustainable-city-management/backend/internal/util"
)

func (server *GatewayService) CollectStationData() error {
	stationIds := []string{"@160051", "@5112", "@364333", "@101290", "@132820", "@22636", "@71989", "@80581", "@128077", "@106501", "@103711", "@77386", "@103714", "@354841", "@215515", "@43741", "@215914", "@354835"}
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
		}
		_, err := server.store.CreateAirData(context.Background(), arg)
		if err != nil {
			log.Fatal(err)
		}
	}
	return nil
}
