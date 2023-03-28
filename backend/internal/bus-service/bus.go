package bus_service

import (
	"context"
	_ "context"
	_ "encoding/json"
	pb "github.com/Eytins/sustainable-city-management/backend/pb/bus/bus-pd"
)

func (server *BusService) GetBusDataByRouteId(ctx context.Context, in *pb.RouteIdRequest) (*pb.GetBusDataByRouteIdResponse, error) {
	routeId := in.GetId()
	data, err := server.store.GetBusDataByRouteId(ctx, routeId)
	if err != nil {
		server.log.Infof("Error fetching Bus data: %v", err)
		return &pb.GetBusDataByRouteIdResponse{}, err
	}
	var res []*pb.InsideGetBusDataByRouteIdResponse
	for _, each := range data {
		res = append(res, &pb.InsideGetBusDataByRouteIdResponse{
			VehicleID:   each.VehicleID,
			Latitude:    float32(each.Latitude),
			Longitude:   float32(each.Longitude),
			RouteID:     each.RouteID,
			DirectionID: each.DirectionID,
		})
	}
	return &pb.GetBusDataByRouteIdResponse{BusData: res}, err
}
