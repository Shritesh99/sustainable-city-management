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

func (s *GatewayService) CollectAirStationData(station string) AQIDATA {
	resp, err := http.Get(fmt.Sprintf("%s/%s/?token=%s", "https://api.waqi.info/feed", station, s.cfg.DB.AIR_TOKEN))
	if err != nil {
		util.LogFatal("Cannot read response body", err)
	}
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		util.LogFatal("Cannot read response body", err)
	}
	var aqi AQIDATA
	json.Unmarshal(body, &aqi)
	return aqi
}
