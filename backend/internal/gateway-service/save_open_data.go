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
			Epa:         resp.Data.Attributions[0].Name,
			Pm25:        float64(resp.Data.Iaqi.Pm25.V),
			Pm10:        float64(resp.Data.Iaqi.Pm10.V),
			Ozone:       resp.Data.Iaqi.O3.V,
			No2:         resp.Data.Iaqi.No2.V,
			So2:         resp.Data.Iaqi.So2.V,
			Co:          float64(resp.Data.Iaqi.Co.V),
			InsertTime:  time.Now(),
			UpdatedTime: time.Now(),
			Latitude:    resp.Data.City.Geo[0],
			Longitude:   resp.Data.City.Geo[1],
		}

		_, err := server.store.CreateAirData(context.Background(), arg)
		if err != nil {
			log.Fatal(err)
		}
	}
	defer func() {
		if r := recover(); r != nil {
			log.Printf("Recovered from panic: %v\n", r)
			log.Println("Panic occurred while creating air data param of db:", r)
		}
	}()
	return nil
}

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
	defer func() {
		if r := recover(); r != nil {
			log.Printf("Recovered from panic: %v\n", r)
			log.Println("Panic occurred while creating noise data param of db:", r)
		}
	}()
	return nil
}

func (server *GatewayService) SaveBusData() error {
	resp := server.CollectBusData()
	for _, data := range resp.Entity {
		arg := db.CreateBusDataParams{
			VehicleID:   data.Vehicle.Vehicle.Id,
			Latitude:    data.Vehicle.Position.Latitude,
			Longitude:   data.Vehicle.Position.Longitude,
			RouteID:     data.Vehicle.Trip.RouteId,
			DirectionID: int32(data.Vehicle.Trip.DirectionId),
		}

		_, err := server.store.CreateBusData(context.Background(), arg)
		if err != nil {
			log.Fatal(err)
		}
	}
	defer func() {
		if r := recover(); r != nil {
			log.Printf("Recovered from panic: %v\n", r)
			log.Println("Panic occurred while creating bus data param of db:", r)
		}
	}()
	return nil
}

func (server *GatewayService) SavePedestrianData() error {
	return nil
}

func (server *GatewayService) SaveBikeData() error {
	resp := server.CollectBikeData()
	for _, data := range resp {
		arg := db.CreateBikeDataParams{
			ID:              int32(data.Number),
			ContractName:    data.ContractName,
			Name:            data.Name,
			Address:         data.Address,
			Latitude:        data.Position.Latitude,
			Longitude:       data.Position.Longitude,
			Status:          data.Status,
			LastUpdate:      data.LastUpdate,
			Bikes:           int32(data.TotalStands.Availabilities.Bikes),
			Stands:          int32(data.TotalStands.Availabilities.Stands),
			MechanicalBikes: int32(data.TotalStands.Availabilities.MechanicalBikes),
			ElectricalBikes: int32(data.TotalStands.Availabilities.ElectricalBikes),
		}

		_, err := server.store.CreateBikeData(context.Background(), arg)
		if err != nil {
			log.Fatal(err)
		}
	}
	defer func() {
		if r := recover(); r != nil {
			log.Printf("Recovered from panic: %v\n", r)
			log.Println("Panic occurred while creating bike data param of db:", r)
		}
	}()
	return nil
}
