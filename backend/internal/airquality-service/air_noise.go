package airquality_service

import (
	"context"
	"encoding/json"
	pb "github.com/Eytins/sustainable-city-management/backend/pb/air-quality/air-pd"
)

func convertToJsonString(err error, data any, server *AirService) (*pb.JsonStringResponse, error) {
	body, err := json.Marshal(&data)
	if err != nil {
		server.log.Infof("Error converting air data: %v", err)
		return &pb.JsonStringResponse{
			Message: "Data converting failed",
		}, err
	}
	return &pb.JsonStringResponse{
		Message: string(body),
	}, nil
}

func (server *AirService) GetAirData(ctx context.Context, in *pb.AirIdRequest) (*pb.JsonStringResponse, error) {
	stationId := in.GetStationId()

	server.log.Infof("station id : %s", stationId)
	airData, err := server.store.GetAirDataByStationId(ctx, stationId)

	if err != nil {
		server.log.Infof("Error fetching air data: %v", err)
		return &pb.JsonStringResponse{
			Message: "Data not found",
		}, err
	}

	return convertToJsonString(err, airData, server)
}

func (server *AirService) GetAQI(ctx context.Context, in *pb.NilRequest) (*pb.JsonStringResponse, error) {
	aqi, err := server.store.GetAQI(ctx)
	if err != nil {
		server.log.Infof("Error fetching AQI data: %v", err)
		return &pb.JsonStringResponse{
			Message: "Data not found",
		}, err
	}

	return convertToJsonString(err, aqi, server)
}

func (server *AirService) GetNoiseData(ctx context.Context, in *pb.NilRequest) (*pb.JsonStringResponse, error) {
	data, err := server.store.GetAllNoiseData(ctx)
	if err != nil {
		server.log.Infof("Error fetching Noise data: %v", err)
		return &pb.JsonStringResponse{
			Message: "Data not found",
		}, err
	}
	return convertToJsonString(err, data, server)
}

// lauda lasson functions
