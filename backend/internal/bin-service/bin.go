package bin_service

import (
	"context"
	_ "encoding/json"
	pb "github.com/Eytins/sustainable-city-management/backend/pb/bin/bin-pd"
)

func (server *BinService) GetAllBins(ctx context.Context, in *pb.GetAllBinsRequest) (*pb.GetAllBinsResponse, error) {
	data, err := server.store.GetAllBinData(ctx)
	if err != nil {
		server.log.Infof("Error fetching Bin data: %v", err)
		return &pb.GetAllBinsResponse{}, err
	}
	var res []*pb.Bin
	for _, each := range data {
		res = append(res, &pb.Bin{
			Id:        each.ID,
			Latitude:  float32(each.Latitude),
			Longitude: float32(each.Longitude),
			Region:    each.Region,
		})
	}
	return &pb.GetAllBinsResponse{Bins: res}, err
}

func (server *BinService) GetBinsByRegion(ctx context.Context, in *pb.GetBinsByRegionRequest) (*pb.GetBinsByRegionResponse, error) {
	data, err := server.store.GetBinDataByRegion(ctx, in.Region)
	if err != nil {
		server.log.Infof("Error fetching Bin data: %v", err)
		return &pb.GetBinsByRegionResponse{}, err
	}
	var res []*pb.Bin
	for _, each := range data {
		res = append(res, &pb.Bin{
			Id:        each.ID,
			Latitude:  float32(each.Latitude),
			Longitude: float32(each.Longitude),
			Region:    each.Region,
		})
	}
	return &pb.GetBinsByRegionResponse{Bins: res}, err
}
