package main

import (
	"helloworld1/handler"
	pb "helloworld1/proto"

	"github.com/micro/micro/v3/service"
	"github.com/micro/micro/v3/service/logger"
)

func main() {
	// Create service
	srv := service.New(
		service.Name("helloworld1"),
	)

	// Register handler
	pb.RegisterHelloworld1Handler(srv.Server(), handler.New())

	// Run service
	if err := srv.Run(); err != nil {
		logger.Fatal(err)
	}
}
