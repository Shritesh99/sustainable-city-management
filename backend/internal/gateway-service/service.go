package gateway_service

import (
	"github.com/Eytins/sustainable-city-management/backend/config"
	db "github.com/Eytins/sustainable-city-management/backend/internal/db/sqlc"
	"github.com/Eytins/sustainable-city-management/backend/pkg/logger"
	"github.com/gofiber/fiber/v2"
	"google.golang.org/grpc"
	"time"
)

type GatewayService struct {
	log            logger.Logger
	router         fiber.Router
	store          *db.SQLStore
	cfg            *config.Config
	airClientConn  *grpc.ClientConn
	busClientConn  *grpc.ClientConn
	bikeClientConn *grpc.ClientConn
	binClientConn  *grpc.ClientConn
}

func NewGatewayService(router fiber.Router, store *db.SQLStore, cfg *config.Config, logger2 logger.Logger, airClientConn *grpc.ClientConn, busClientConn *grpc.ClientConn, bikeClientConn *grpc.ClientConn, binClientConn *grpc.ClientConn) *GatewayService {
	server := &GatewayService{router: router, store: store, cfg: cfg, log: logger2, airClientConn: airClientConn, busClientConn: busClientConn, bikeClientConn: bikeClientConn, binClientConn: binClientConn}
	router.Post("/register", server.Register)
	router.Post("/login", server.Login)
	router.Post("/logout", server.Logout)
	router.Post("/profile", server.GetProfile)
	router.Get("/getRoles", server.GetRoles)
	router.Get("/getAirStation", server.GetAirStation)
	router.Get("/getDetailedAirData", server.GetDetailedAirData)
	router.Get("/getNoiseData", server.GetNoiseData)
	router.Get("/getBusDataByRouteId", server.GetBusDataByRouteId)
	router.Get("/getBikes", server.GetBikes)
	router.Get("/getAllBins", server.GetAllBins)
	router.Get("/getBinsByRegion", server.GetBinsByRegion)

	go CollectDataTimerTask(server, logger2)
	//go CollectCsvTimerTask(server, logger2)
	return server
}

func CollectDataTimerTask(server *GatewayService, logger logger.Logger) {
	for {
		err := server.CollectStationData()
		if err != nil {
			logger.Fatal("Collect air station data failed")
		}
		err = server.SaveNoiseData()
		if err != nil {
			logger.Fatal("Collect noise data failed")
		}
		err = server.SaveBusData()
		if err != nil {
			logger.Fatal("Collect bus data failed")
		}
		err = server.SaveBikeData()
		if err != nil {
			logger.Fatal("Collect bike data failed")
		}
		//err = server.SaveBinData()
		//if err != nil {
		//	logger.Fatal("Collect bin data failed")
		//}
		time.Sleep(1 * time.Hour)
	}
}

func CollectCsvTimerTask(server *GatewayService, logger logger.Logger) {
	for {
		err := server.SavePedestrianData()
		if err != nil {
			logger.Fatal("Collect csv data failed")
		}
		time.Sleep(24 * time.Hour)
	}
}
