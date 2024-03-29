package gateway_service

import (
	"github.com/Eytins/sustainable-city-management/backend/config"
	db "github.com/Eytins/sustainable-city-management/backend/internal/db/sqlc"
	"github.com/Eytins/sustainable-city-management/backend/pkg/logger"
	"github.com/gofiber/fiber/v2"
	"google.golang.org/grpc"
	"os/exec"
	"path/filepath"
	"runtime"
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
	router.Get("/getPedestrianByTime", server.GetPedestrianDataByTime)
	router.Get("/getPredictedAirData", server.GetPredictedAirData)
	router.Get("/getPredictedAirStations", server.GetPredictedAirStations)
	router.Get("/getPredictedDetailedAirData", server.GetPredictedDetailedAirData)

	go CollectDataTimerTask(server, logger2)
	//go InitCollectCsvTimerTask(server, logger2)
	//go UpdateCsvTimerTask(server, logger2)

	// This is done in python
	//go UpdateAirDataTimerTask(server, logger2)
	return server
}

func CollectDataTimerTask(server *GatewayService, logger logger.Logger) {
	for {
		err := server.SaveStationData()
		if err != nil {
			logger.Fatal("Collect air station data failed")
		}
		time.Sleep(12 * time.Minute)
		err = server.SaveNoiseData()
		if err != nil {
			logger.Fatal("Collect noise data failed")
		}
		time.Sleep(12 * time.Minute)
		err = server.SaveBusData()
		if err != nil {
			logger.Fatal("Collect bus data failed")
		}
		time.Sleep(12 * time.Minute)
		err = server.SaveBikeData()
		if err != nil {
			logger.Fatal("Collect bike data failed")
		}
		time.Sleep(12 * time.Minute)
		err = server.ChangeBinStatus()
		if err != nil {
			logger.Fatal("Change bin status failed")
		}
		time.Sleep(12 * time.Minute)
	}
}

func InitCollectCsvTimerTask(server *GatewayService, logger logger.Logger) {
	for {
		err := server.SavePedestrianData()
		if err != nil {
			logger.Fatal("Collect csv data failed")
		}
		time.Sleep(24 * time.Hour)
	}
}

func UpdateCsvTimerTask(server *GatewayService, logger logger.Logger) {
	// Get current time
	now := time.Now()
	// Get next day time
	nextDay := now.Add(24 * time.Hour)
	// Get next day zero time
	nextDayZero := time.Date(nextDay.Year(), nextDay.Month(), nextDay.Day(), 0, 0, 0, 0, nextDay.Location())
	// Get next day zero time duration
	nextDayZeroDuration := nextDayZero.Sub(now)
	// Sleep for next day zero time duration
	time.Sleep(nextDayZeroDuration)
	for {
		// Predict pedestrian data for next day
		_, path, _, _ := runtime.Caller(0)
		//venvPath := filepath.Join(path, "../../ml/venv/bin/activate")
		pyPath := filepath.Join(path, "../../ml/ase_ml.py")
		cmd := exec.Command("python " + pyPath)
		//cmd := exec.Command("python3", pyPath)
		_, err := cmd.Output()
		if err != nil {
			logger.Fatal("Predict csv data failed: ", err)
		}

		// Update pedestrian data
		err = server.UpdatePedestrianData()
		if err != nil {
			logger.Fatal("Update csv data failed")
		}
		time.Sleep(24 * time.Hour)
	}
}

func UpdateAirDataTimerTask(server *GatewayService, logger logger.Logger) {
	for {
		// Predict pedestrian data for next day
		_, path, _, _ := runtime.Caller(0)
		//venvPath := filepath.Join(path, "../../ml/venv/bin/activate")
		pyPath := filepath.Join(path, "../../ml/air.py")
		cmd := exec.Command("python " + pyPath)
		//cmd := exec.Command("python3", pyPath)
		_, err := cmd.Output()
		if err != nil {
			logger.Fatal("Predict csv data failed: ", err)
		}

		// Update pedestrian data
		err = server.UpdatePedestrianData()
		if err != nil {
			logger.Fatal("Update csv data failed")
		}
		time.Sleep(1 * time.Hour)
	}
}
