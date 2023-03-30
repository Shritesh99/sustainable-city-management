package bike_service

import (
	"context"
	_ "encoding/json"
	_ "github.com/Eytins/sustainable-city-management/backend/pb/bike/bike-pd"
	pb "github.com/Eytins/sustainable-city-management/backend/pb/bike/bike-pd"
)

func (server *BikeService) GetBikes(ctx context.Context, in *pb.GetBikesRequest) (*pb.GetBikesResponse, error) {
	data, err := server.store.GetAllBikeData(ctx)
	if err != nil {
		server.log.Infof("Error fetching Bike data: %v", err)
		return &pb.GetBikesResponse{}, err
	}
	var res []*pb.Bike
	for _, each := range data {
		res = append(res, &pb.Bike{
			Id:              each.ID,
			ContractName:    each.ContractName,
			Name:            each.Name,
			Address:         each.Address,
			Latitude:        float32(each.Latitude),
			Longitude:       float32(each.Longitude),
			Status:          each.Status,
			LastUpdate:      each.LastUpdate.Unix(),
			Bikes:           each.Bikes,
			Stands:          each.Stands,
			MechanicalBikes: each.MechanicalBikes,
			ElectricalBikes: each.ElectricalBikes,
		})
	}
	return &pb.GetBikesResponse{Bikes: res}, err
}
