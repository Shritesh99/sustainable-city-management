package main

import (
	"context"
	pb "github.com/Eytins/sustainable-city-management/backend/pb/air-quality/air-pd"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"testing"
)

func TestName(t *testing.T) {
	airClientConn, err := grpc.Dial("127.0.0.1:4000", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		print(err)
	}
	client := pb.NewAirServiceClient(airClientConn)
	var req = new(pb.NilRequest)
	resp, err := client.GetAQI(context.Background(), req)
	if err != nil {
		print("Error")
	}
	print(resp.GetMessage())
}
