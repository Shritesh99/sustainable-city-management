package airquality_service

import (
	"context"
	pb "github.com/Eytins/sustainable-city-management/backend/pb/air-quality/air-pd"
	"time"
)

func (server *AirService) GetAirStation(ctx context.Context, in *pb.AirIdRequest) (*pb.GetAirStationResponse, error) {
	stationId := in.GetStationId()

	server.log.Infof("station id : %s", stationId)
	airData, err := server.store.GetAirDataByStationId(ctx, stationId)

	if err != nil {
		server.log.Infof("Error fetching air data: %v", err)
		return &pb.GetAirStationResponse{}, err
	}

	return &pb.GetAirStationResponse{
		Id:          airData.ID,
		StationId:   airData.StationID,
		StationName: airData.StationName,
		Aqi:         float32(airData.Aqi),
		MeasureTime: airData.MeasureTime,
		Epa:         airData.Epa,
		Pm25:        float32(airData.Pm25),
		Pm10:        float32(airData.Pm10),
		Ozone:       float32(airData.Ozone),
		No2:         float32(airData.No2),
		So2:         float32(airData.So2),
		Co:          float32(airData.Co),
		InsertTime:  airData.InsertTime.Unix(),
		UpdateTime:  airData.UpdatedTime.Unix(),
		Latitude:    float32(airData.Latitude),
		Longitude:   float32(airData.Longitude),
	}, nil
}

func (server *AirService) GetDetailedAirData(ctx context.Context, in *pb.NilRequest) (*pb.GetDetailedAirDataResponse, error) {
	aqi, err := server.store.GetAQI(ctx)
	if err != nil {
		server.log.Infof("Error fetching AQI data: %v", err)
		return &pb.GetDetailedAirDataResponse{}, err
	}
	var res []*pb.InsideGetDetailedAirDataResponse
	for _, each := range aqi {
		res = append(res, &pb.InsideGetDetailedAirDataResponse{
			StationID:   each.StationID,
			StationName: each.StationName,
			Latitude:    float32(each.Latitude),
			Longitude:   float32(each.Longitude),
			Aqi:         float32(each.Aqi),
		})
	}
	return &pb.GetDetailedAirDataResponse{
		AirData: res,
	}, err
}

func (server *AirService) GetNoiseData(ctx context.Context, in *pb.NilRequest) (*pb.GetNoiseDataResponse, error) {
	data, err := server.store.GetAllNoiseData(ctx)
	if err != nil {
		server.log.Infof("Error fetching Noise data: %v", err)
		return &pb.GetNoiseDataResponse{}, err
	}
	var res []*pb.InsideGetNoiseDataResponse
	for _, each := range data {
		res = append(res, &pb.InsideGetNoiseDataResponse{
			MonitorID:     each.MonitorID,
			Location:      each.Location,
			Latitude:      each.Latitude,
			Longitude:     each.Longitude,
			RecordTime:    each.RecordTime,
			Laeq:          float32(each.Laeq),
			CurrentRating: each.CurrentRating,
			DailyAvg:      float32(each.DailyAvg),
			HourlyAvg:     float32(each.HourlyAvg),
		})
	}
	return &pb.GetNoiseDataResponse{
		NoiseData: res,
	}, err
}

func (server *AirService) GetPedestrianDataByTime(ctx context.Context, in *pb.TimeRequest) (*pb.GetPedestrianDataResponse, error) {
	reqTime := in.GetTime()
	// Convert timestamp to time.Time
	t := time.Unix(reqTime, 0)
	data, err := server.store.GetPedestrianByTime(ctx, t)
	if err != nil {
		server.log.Infof("Error fetching Pedestrian data: %v", err)
		return &pb.GetPedestrianDataResponse{}, err
	}
	var res []*pb.InsideGetPedestrianDataResponse
	for _, each := range data {
		res = append(res, &pb.InsideGetPedestrianDataResponse{
			Id:         each.ID,
			StreetName: each.StreetName,
			Latitude:   float32(each.Latitude),
			Longitude:  float32(each.Longitude),
			Time:       each.Time.Unix(),
			Amount:     each.Amount,
		})
	}
	return &pb.GetPedestrianDataResponse{
		PedestrianData: res,
	}, err
}

// lauda lasson functions
