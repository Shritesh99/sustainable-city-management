package gateway_service

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"

	"github.com/Eytins/sustainable-city-management/backend/internal/util"
)

type LatLongResponse struct {
	Data   json.RawMessage `json:"data"`
	Status string          `json:"status"`
}

func (s *GatewayService) CollectAirStationData(station string) []byte {
	resp, err := http.Get(fmt.Sprintf("%s/%s/?token=%s", "https://api.waqi.info/feed", station, s.cfg.DB.AIR_TOKEN))
	if err != nil {
		util.LogFatal("Cannot read response body", err)
	}
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		util.LogFatal("Cannot read response body", err)
	}
	return body
}
