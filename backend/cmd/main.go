package main

import (
	"flag"
	"log"

	"github.com/Eytins/sustainable-city-management/backend/config"
	common_service "github.com/Eytins/sustainable-city-management/backend/internal/common-service"
	"github.com/Eytins/sustainable-city-management/backend/pkg/logger"
	"github.com/honeybadger-io/honeybadger-go"
)

func main() {
	defer honeybadger.Monitor()
	log.Println("Starting...")

	flag.Parse()

	cfg, err := config.InitConfig()
	if err != nil {
		log.Fatal(err)
	}
	honeybadger.SetContext(honeybadger.Context{"Service_Name": cfg.ServiceName})
	if cfg.Development {
		honeybadger.Configure(honeybadger.Configuration{Backend: honeybadger.NewNullBackend()})
	} else {
		honeybadger.Configure(honeybadger.Configuration{APIKey: cfg.Honeybadger_API_KEY})
	}
	appLogger := logger.NewAppLogger(cfg.Logger)
	appLogger.InitLogger()

	appLogger.Named(common_service.GetMicroserviceName(cfg))
	appLogger.Infof("CFG: %+v", cfg)
	common_service.NewService(appLogger, cfg).Run()
}
