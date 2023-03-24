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