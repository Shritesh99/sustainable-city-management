package main

import (
	"flag"
	"log"

	"github.com/Eytins/sustainable-city-management/backend/config"
	common_service "github.com/Eytins/sustainable-city-management/backend/internal/common-service"
	"github.com/Eytins/sustainable-city-management/backend/pkg/logger"
)

type server struct {
}

func main() {
	log.Println("Starting...")

	flag.Parse()

	cfg, err := config.InitConfig()
	if err != nil {
		log.Fatal(err)
	}

	appLogger := logger.NewAppLogger(cfg.Logger)
	appLogger.InitLogger()

	appLogger.Named(common_service.GetMicroserviceName(cfg))
	appLogger.Infof("CFG: %+v", cfg)
	appLogger.Fatal(common_service.NewService(appLogger, cfg).Run())
}
