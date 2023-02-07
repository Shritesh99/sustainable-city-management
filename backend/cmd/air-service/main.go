package main

import (
	"flag"
	"log"
	"sustinable-city-management/config"
	"sustinable-city-management/pkg/logger"
)

type server struct {
}

func main() {
	log.Println("Starting microservice Air")

	flag.Parse()

	cfg, err := config.InitConfig()
	if err != nil {
		log.Fatal(err)
	}

	appLogger := logger.NewAppLogger(cfg.Logger)
	appLogger.InitLogger()
	// appLogger.Named(app.GetMicroserviceName(cfg))
	appLogger.Infof("CFG: %+v", cfg)
	// appLogger.Fatal(app.NewApp(appLogger, cfg).Run())

}
