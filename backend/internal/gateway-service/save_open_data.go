package gateway_service

import (
	"context"
	"encoding/csv"
	db "github.com/Eytins/sustainable-city-management/backend/internal/db/sqlc"
	"github.com/Eytins/sustainable-city-management/backend/internal/util"
	"log"
	"math/rand"
	"os"
	"path/filepath"
	"runtime"
	"strconv"
	"time"
	// "github.com/Eytins/sustainable-city-management/backend/internal/util"
)

func (server *GatewayService) SaveStationData() error {
	stationIds := server.CollectAirStationIds()
	for _, v := range stationIds {
		resp := server.CollectAirStationData(v)
		if resp.Data.Attributions == nil {
			continue
		}
		arg := db.CreateAirDataParams{
			StationID:   v,
			StationName: resp.Data.City.Name,
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
	return savePedestrianDataToDb(server, 72)
}

func savePedestrianDataToDb(server *GatewayService, hrs int) error {
	_, path, _, _ := runtime.Caller(0)
	f, err := os.Open(filepath.Join(path, "../../ml/pedestrian.csv"))
	if err != nil {
		util.LogFatal("Read pedestrian csv file failed ", err)
		return err
	}
	f1, err := os.Open(filepath.Join(path, "../../ml/dcc-footfall-counter-locations-14082020.csv"))
	if err != nil {
		util.LogFatal("Read location csv file failed", err)
		return err
	}

	csvReader := csv.NewReader(f)
	data, err := csvReader.ReadAll()
	locReader := csv.NewReader(f1)
	locations, err := locReader.ReadAll()
	if err != nil {
		util.LogFatal("Parse pedestrian csv file failed", err)
		return err
	}

	strNameMap := make(map[string][]float64)
	for i := 1; i < len(locations); i++ {
		latitude, _ := strconv.ParseFloat(locations[i][1], 64)
		longitude, _ := strconv.ParseFloat(locations[i][2], 64)
		strNameMap[locations[i][0]] = []float64{latitude, longitude}
	}

	var strNames []string
	strNames = append(strNames, "")
	for i := 1; i < len(data[0]); i++ {
		strNames = append(strNames, data[0][i])
	}
	for i := len(data) - hrs; i < len(data); i++ {
		for j := 1; j < len(data[i]); j++ {
			stamp, err := time.Parse("2006-01-02 15:04:05", data[i][0])
			if err != nil {
				return err
			}
			amount, err := strconv.Atoi(data[i][j])

			arg := db.CreatePedestrianParams{
				StreetName: strNames[j],
				Latitude:   strNameMap[strNames[j]][0],
				Longitude:  strNameMap[strNames[j]][1],
				Time:       stamp,
				Amount:     int32(amount),
			}
			_, err = server.store.CreatePedestrian(context.Background(), arg)
			if err != nil {
				util.LogFatal("Create pedestrian data param of db failed: ", err)
				return err
			}
		}
	}

	err = f.Close()
	if err != nil {
		util.LogFatal("Close pedestrian csv file failed", err)
		return err
	}

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

func (server *GatewayService) SaveBinData() error {
	resp := server.CollectBinData()
	for i, data := range resp.Features {
		if i%13 != 0 {
			continue
		}
		var region int
		if data.Geometry.Coordinates[0] < -6.308742151386624 {
			region = 1
		} else if -6.308742151386624 <= data.Geometry.Coordinates[0] && data.Geometry.Coordinates[0] < -6.291845689366002 {
			region = 2
		} else if -6.291845689366002 <= data.Geometry.Coordinates[0] && data.Geometry.Coordinates[0] < -6.274597217719949 {
			region = 3
		} else if -6.274597217719949 <= data.Geometry.Coordinates[0] && data.Geometry.Coordinates[0] < -6.259460803826475 {
			region = 4
		} else if -6.259460803826475 <= data.Geometry.Coordinates[0] && data.Geometry.Coordinates[0] < -6.245380418809289 {
			region = 5
		} else if -6.245380418809289 <= data.Geometry.Coordinates[0] && data.Geometry.Coordinates[0] < -6.2358761589226885 {
			region = 6
		} else {
			region = 7
		}

		rand.Seed(time.Now().UnixNano())
		arg := db.CreateBinDataParams{
			ID:        data.Properties.BinID,
			Latitude:  data.Geometry.Coordinates[0],
			Longitude: data.Geometry.Coordinates[1],
			Region:    int32(region),
			Status:    int32(rand.Intn(2)),
		}

		_, err := server.store.CreateBinData(context.Background(), arg)
		if err != nil {
			log.Fatal(err)
		}
	}
	defer func() {
		if r := recover(); r != nil {
			log.Printf("Recovered from panic: %v\n", r)
			log.Println("Panic occurred while creating bin data param of db:", r)
		}
	}()
	return nil
}

func (server *GatewayService) ChangeBinStatus() error {
	ids, err := server.store.GetBinIds(context.Background())
	if err != nil {
		return err
	}
	for _, id := range ids {
		rand.Seed(time.Now().UnixNano())
		arg := db.ChangeBinDataStatusParams{
			ID:     id,
			Status: int32(rand.Intn(2)),
		}
		err := server.store.ChangeBinDataStatus(context.Background(), arg)
		if err != nil {
			return err
		}
	}
	return nil
}

func (server *GatewayService) UpdatePedestrianData() error {
	// Delete 552
	ids, err := server.store.GetFirstPedestrianIdsOfOneDay(context.Background())
	if err != nil {
		return err
	}
	for _, id := range ids {
		err := server.store.DeletePedestrian(context.Background(), id)
		if err != nil {
			return err
		}
	}

	// Insert 552
	return savePedestrianDataToDb(server, 24)
}
