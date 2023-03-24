package bus_service

import (
	"context"
	_ "context"
	"encoding/json"
	_ "encoding/json"
	pb "github.com/Eytins/sustainable-city-management/backend/pb/bus/bus-pd"
)

func (server *BusService) GetBusDataByRouteId(ctx context.Context, in *pb.RouteIdRequest) (*pb.BusJsonStringResponse, error) {
	routeId := in.GetId()
	data, err := server.store.GetBusDataByRouteId(ctx, routeId)
	if err != nil {
		server.log.Infof("Error fetching Bus data: %v", err)
		return &pb.BusJsonStringResponse{
			Message: "Data not found",
		}, err
	}
	return convertToJsonString(err, data, server)
}

func convertToJsonString(err error, data any, server *BusService) (*pb.BusJsonStringResponse, error) {
	body, err := json.Marshal(&data)
	if err != nil {
		server.log.Infof("Error converting air data: %v", err)
		return &pb.BusJsonStringResponse{
			Message: "Data converting failed",
		}, err
	}
	return &pb.BusJsonStringResponse{
		Message: string(body),
	}, nil
}
