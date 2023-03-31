package gateway_service

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"

	"github.com/Eytins/sustainable-city-management/backend/internal/util"
)

type AQIDATA struct {
	Status string `json:"status"`
	Data   struct {
		Aqi          int `json:"aqi"`
		Idx          int `json:"idx"`
		Attributions []struct {
			URL  string `json:"url"`
			Name string `json:"name"`
		} `json:"attributions"`
		City struct {
			Geo      []float64 `json:"geo"`
			Name     string    `json:"name"`
			URL      string    `json:"url"`
			Location string    `json:"location"`
		} `json:"city"`
		Dominentpol string `json:"dominentpol"`
		Iaqi        struct {
			Co struct {
				V int `json:"v"`
			} `json:"co"`
			H struct {
				V float64 `json:"v"`
			} `json:"h"`
			No2 struct {
				V float64 `json:"v"`
			} `json:"no2"`
			O3 struct {
				V float64 `json:"v"`
			} `json:"o3"`
			P struct {
				V float64 `json:"v"`
			} `json:"p"`
			Pm10 struct {
				V int `json:"v"`
			} `json:"pm10"`
			Pm25 struct {
				V int `json:"v"`
			} `json:"pm25"`
			So2 struct {
				V float64 `json:"v"`
			} `json:"so2"`
			T struct {
				V float64 `json:"v"`
			} `json:"t"`
			W struct {
				V float64 `json:"v"`
			} `json:"w"`
		} `json:"iaqi"`
		Time struct {
			S   string    `json:"s"`
			Tz  string    `json:"tz"`
			V   int       `json:"v"`
			Iso time.Time `json:"iso"`
		} `json:"time"`
		Forecast struct {
			Daily struct {
				O3 []struct {
					Avg int    `json:"avg"`
					Day string `json:"day"`
					Max int    `json:"max"`
					Min int    `json:"min"`
				} `json:"o3"`
				Pm10 []struct {
					Avg int    `json:"avg"`
					Day string `json:"day"`
					Max int    `json:"max"`
					Min int    `json:"min"`
				} `json:"pm10"`
				Pm25 []struct {
					Avg int    `json:"avg"`
					Day string `json:"day"`
					Max int    `json:"max"`
					Min int    `json:"min"`
				} `json:"pm25"`
				Uvi []struct {
					Avg int    `json:"avg"`
					Day string `json:"day"`
					Max int    `json:"max"`
					Min int    `json:"min"`
				} `json:"uvi"`
			} `json:"daily"`
		} `json:"forecast"`
		Debug struct {
			Sync time.Time `json:"sync"`
		} `json:"debug"`
	} `json:"data"`
}

func (server *GatewayService) CollectAirStationData(station string) AQIDATA {
	resp, err := http.Get(fmt.Sprintf("%s/%s/?token=%s", "https://api.waqi.info/feed", station, server.cfg.DB.AIR_TOKEN))
	if err != nil {
		util.LogFatal("Cannot read response body", err)
	}
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		util.LogFatal("Cannot read response body", err)
	}
	var aqi AQIDATA
	err = json.Unmarshal(body, &aqi)
	if err != nil {
		return AQIDATA{}
	}
	return aqi
}

type NOISEDATA []struct {
	MonitorId       int     `json:"monitor_id"`
	Label           string  `json:"label"`
	Location        string  `json:"location"`
	Latitude        string  `json:"latitude"`
	Longitude       string  `json:"longitude"`
	Code            string  `json:"code"`
	SerialNumber    string  `json:"serial_number"`
	LastCalibrated  *string `json:"last_calibrated"`
	MonitorTypeId   int     `json:"monitor_type_id"`
	LatestReadingId int     `json:"latest_reading_id"`
	MonitorType     struct {
		MonitorTypeId      int     `json:"monitor_type_id"`
		Name               string  `json:"name"`
		Manufacturer       string  `json:"manufacturer"`
		Category           string  `json:"category"`
		SampleCode         string  `json:"sample_code"`
		SampleSerialNumber string  `json:"sample_serial_number"`
		Protocol           *string `json:"protocol"`
	} `json:"monitor_type"`
	LatestReading struct {
		ReadingId    int      `json:"reading_id,omitempty"`
		MonitorId    int      `json:"monitor_id"`
		ProjectId    int      `json:"project_id"`
		RecordedAt   string   `json:"recorded_at"`
		Laeq         float64  `json:"laeq,omitempty"`
		Date         string   `json:"date"`
		Time         string   `json:"time"`
		SecsSince    int      `json:"secs_since"`
		TimeSince    string   `json:"time_since"`
		Status       string   `json:"status"`
		AirReadingId int      `json:"air_reading_id,omitempty"`
		Pm10         *float64 `json:"pm10,omitempty"`
		Pm25         *float64 `json:"pm2_5,omitempty"`
		No2          *float64 `json:"no2,omitempty"`
		O3           *float64 `json:"o3,omitempty"`
		So2          *float64 `json:"so2,omitempty"`
		Co           *float64 `json:"co,omitempty"`
	} `json:"latest_reading"`
	LatestAverage struct {
		AverageId int     `json:"average_id"`
		LimitId   int     `json:"limit_id"`
		MonitorId int     `json:"monitor_id"`
		Date      string  `json:"date"`
		Value     float64 `json:"value"`
		Breach    int     `json:"breach"`
		Final     int     `json:"final"`
		CreatedAt string  `json:"created_at"`
		UpdatedAt string  `json:"updated_at"`
		StartTime string  `json:"start_time"`
		EndTime   string  `json:"end_time"`
		Day       string  `json:"day"`
	} `json:"latest_average,omitempty"`
	LatestHourlyAverage struct {
		HourlyAverageId int     `json:"hourly_average_id"`
		MonitorId       int     `json:"monitor_id"`
		Datetime        string  `json:"datetime"`
		Value           float64 `json:"value"`
		Day             string  `json:"day"`
	} `json:"latest_hourly_average,omitempty"`
	NumReadings    string `json:"num_readings"`
	CurrentRating  int    `json:"current_rating"`
	LatestAverages struct {
		So2 struct {
			Start             string  `json:"start"`
			End               string  `json:"end"`
			Value             float64 `json:"value"`
			NumReadings       int     `json:"num_readings"`
			PercentageCapture int     `json:"percentage_capture"`
			Rating            int     `json:"rating"`
		} `json:"so2,omitempty"`
		Co struct {
			Start             string      `json:"start"`
			End               string      `json:"end"`
			Value             float64     `json:"value"`
			NumReadings       int         `json:"num_readings"`
			PercentageCapture int         `json:"percentage_capture"`
			Rating            interface{} `json:"rating"`
		} `json:"co,omitempty"`
		Pm10 struct {
			Start             string  `json:"start"`
			End               string  `json:"end"`
			Value             float64 `json:"value"`
			NumReadings       int     `json:"num_readings"`
			PercentageCapture int     `json:"percentage_capture"`
			Rating            int     `json:"rating,omitempty"`
		} `json:"pm10,omitempty"`
		Pm25 struct {
			Start             string  `json:"start"`
			End               string  `json:"end"`
			Value             float64 `json:"value"`
			NumReadings       int     `json:"num_readings"`
			PercentageCapture int     `json:"percentage_capture"`
			Rating            int     `json:"rating,omitempty"`
		} `json:"pm2_5,omitempty"`
		No2 struct {
			Start             string  `json:"start"`
			End               string  `json:"end"`
			Value             float64 `json:"value"`
			NumReadings       int     `json:"num_readings"`
			PercentageCapture int     `json:"percentage_capture"`
			Rating            int     `json:"rating"`
		} `json:"no2,omitempty"`
		O3 struct {
			Start             string  `json:"start"`
			End               string  `json:"end"`
			Value             float64 `json:"value"`
			NumReadings       int     `json:"num_readings"`
			PercentageCapture int     `json:"percentage_capture"`
			Rating            int     `json:"rating"`
		} `json:"o3,omitempty"`
	} `json:"latest_averages,omitempty"`
}

func (server *GatewayService) CollectNoiseData() NOISEDATA {
	resp, err := http.Get("https://dublincityairandnoise.ie/assets/php/get-monitors.php")
	if err != nil {
		util.LogFatal("Cannot get data from noise api", err)
		return nil
	}
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		util.LogFatal("Cannot read response noise body", err)
		return nil
	}
	var noise NOISEDATA
	err = json.Unmarshal(body, &noise)
	if err != nil {
		util.LogFatal("Cannot convert noise response body to json", err)
		return nil
	}
	return noise
}

type BUSDATA struct {
	Header struct {
		GtfsRealtimeVersion string `json:"gtfs_realtime_version"`
		Incrementality      string `json:"incrementality"`
		Timestamp           string `json:"timestamp"`
	} `json:"header"`
	Entity []struct {
		Id      string `json:"id"`
		Vehicle struct {
			Trip struct {
				TripId               string `json:"trip_id"`
				StartTime            string `json:"start_time"`
				StartDate            string `json:"start_date"`
				ScheduleRelationship string `json:"schedule_relationship"`
				RouteId              string `json:"route_id"`
				DirectionId          int    `json:"direction_id"`
			} `json:"trip"`
			Position struct {
				Latitude  float64 `json:"latitude"`
				Longitude float64 `json:"longitude"`
			} `json:"position"`
			Timestamp string `json:"timestamp"`
			Vehicle   struct {
				Id string `json:"id"`
			} `json:"vehicle"`
		} `json:"vehicle"`
	} `json:"entity"`
}

func (server *GatewayService) CollectBusData() BUSDATA {
	var bus BUSDATA
	req, err := http.NewRequest("GET", "https://api.nationaltransport.ie/gtfsr/v2/Vehicles?format=json", nil)
	req.Header.Set("x-api-key", "e4c8038e1781436f857aa347bcb67d05")
	req.Header.Set("Cache-Control", "no-cache")
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		util.LogFatal("Cannot get data from bus api", err)
		return bus
	}
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		util.LogFatal("Cannot read response bus body", err)
		return bus
	}
	err = json.Unmarshal(body, &bus)
	if err != nil {
		util.LogFatal("Cannot convert bus response body to json", err)
		return bus
	}
	return bus
}

//func (server *GatewayService) CollectPedestrianData() {
//	f, err := os.Open("/ml/pedestrian.csv")
//	f1, err := os.Open("/ml/dcc-footfall-counter-locations-14082020.csv")
//	if err != nil {
//		util.LogFatal("Read pedestrian csv file failed", err)
//	}
//
//	csvReader := csv.NewReader(f)
//	data, err := csvReader.ReadAll()
//	locReader := csv.NewReader(f1)
//	locations, err := locReader.ReadAll()
//	if err != nil {
//		util.LogFatal("Parse pedestrian csv file failed", err)
//	}
//
//	var strNameMap map[string][]float64
//	for i := 1; i < len(locations); i++ {
//		latitude, _ := strconv.ParseFloat(locations[i][1], 64)
//		longitude, _ := strconv.ParseFloat(locations[i][2], 64)
//		strNameMap[locations[i][0]] = []float64{latitude, longitude}
//	}
//
//	var strNames []string
//	for i := 1; i < len(data[0]); i++ {
//		strNames = append(strNames, data[0][i])
//	}
//	for i := 1; i < len(data); i++ {
//		for j := 0; j < len(data[i]); j++ {
//			server.store.CreatePedestrian()
//		}
//	}
//
//	err = f.Close()
//	if err != nil {
//		util.LogFatal("Close pedestrian csv file failed", err)
//		return
//	}
//}

type BIKEDATA []struct {
	Number       int    `json:"number"`
	ContractName string `json:"contractName"`
	Name         string `json:"name"`
	Address      string `json:"address"`
	Position     struct {
		Latitude  float64 `json:"latitude"`
		Longitude float64 `json:"longitude"`
	} `json:"position"`
	Banking     bool        `json:"banking"`
	Bonus       bool        `json:"bonus"`
	Status      string      `json:"status"`
	LastUpdate  time.Time   `json:"lastUpdate"`
	Connected   bool        `json:"connected"`
	Overflow    bool        `json:"overflow"`
	Shape       interface{} `json:"shape"`
	TotalStands struct {
		Availabilities struct {
			Bikes                           int `json:"bikes"`
			Stands                          int `json:"stands"`
			MechanicalBikes                 int `json:"mechanicalBikes"`
			ElectricalBikes                 int `json:"electricalBikes"`
			ElectricalInternalBatteryBikes  int `json:"electricalInternalBatteryBikes"`
			ElectricalRemovableBatteryBikes int `json:"electricalRemovableBatteryBikes"`
		} `json:"availabilities"`
		Capacity int `json:"capacity"`
	} `json:"totalStands"`
	MainStands struct {
		Availabilities struct {
			Bikes                           int `json:"bikes"`
			Stands                          int `json:"stands"`
			MechanicalBikes                 int `json:"mechanicalBikes"`
			ElectricalBikes                 int `json:"electricalBikes"`
			ElectricalInternalBatteryBikes  int `json:"electricalInternalBatteryBikes"`
			ElectricalRemovableBatteryBikes int `json:"electricalRemovableBatteryBikes"`
		} `json:"availabilities"`
		Capacity int `json:"capacity"`
	} `json:"mainStands"`
	OverflowStands interface{} `json:"overflowStands"`
}

func (server *GatewayService) CollectBikeData() BIKEDATA {
	resp, err := http.Get("https://api.jcdecaux.com/vls/v3/stations?apiKey=frifk0jbxfefqqniqez09tw4jvk37wyf823b5j1i&contract=dublin")
	if err != nil {
		util.LogFatal("Cannot get data from bike api", err)
		return nil
	}
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		util.LogFatal("Cannot read response bike body", err)
		return nil
	}
	var bike BIKEDATA
	err = json.Unmarshal(body, &bike)
	if err != nil {
		util.LogFatal("Cannot convert bike response body to json", err)
		return nil
	}
	return bike
}

type BINDATA struct {
	Crs struct {
		Properties struct {
			Name string `json:"name"`
		} `json:"properties"`
		Type string `json:"type"`
	} `json:"crs"`
	Features []struct {
		Geometry struct {
			Coordinates []float64 `json:"coordinates"`
			Type        string    `json:"type"`
		} `json:"geometry"`
		Properties struct {
			BinID         string  `json:"Bin_ID"`
			BinType       string  `json:"Bin_Type"`
			ElectoralArea string  `json:"Electoral_Area"`
			IrishX        float64 `json:"Irish_X"`
			IrishY        float64 `json:"Irish_Y"`
		} `json:"properties"`
		Type string `json:"type"`
	} `json:"features"`
	Type string `json:"type"`
}

func (server *GatewayService) CollectBinData() BINDATA {
	resp, err := http.Get("https://data.smartdublin.ie/dataset/6cbabf95-6b81-48e7-a2b8-b2345bbe80a1/resource/68e46a6b-383c-4f67-888c-95210e695df1/download/dcc_public_bin_locations.geojson")
	if err != nil {
		util.LogFatal("Cannot get data from bin api", err)
		return BINDATA{}
	}
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		util.LogFatal("Cannot read response bin body", err)
		return BINDATA{}
	}
	var bin BINDATA
	err = json.Unmarshal(body, &bin)
	if err != nil {
		util.LogFatal("Cannot convert bin response body to json", err)
		return BINDATA{}
	}
	return bin
}
