package airquality_service

import (
	"context"
	"encoding/json"
	pb "github.com/Eytins/sustainable-city-management/backend/pb/air-quality/air-pd"
)

func (server *AirService) GetAirData(ctx context.Context, in *pb.AirIdRequest) (*pb.GetAirDataResponse, error) {
	stationId := in.GetStationId()

	server.log.Infof("station id : %s", stationId)
	aqi, err := server.store.GetAirDataByStationId(ctx, stationId)

	if err != nil {
		server.log.Infof("Error fetching air data: %v", err)
		return &pb.GetAirDataResponse{
			Message: "Data not found",
		}, err
	}

	body, err := json.Marshal(&aqi)

	if err != nil {
		server.log.Infof("Error converting air data: %v", err)
		return &pb.GetAirDataResponse{
			Message: "Data converting failed",
		}, err
	}

	return &pb.GetAirDataResponse{
		Message: string(body),
	}, nil
}

// lauda lasson functions
