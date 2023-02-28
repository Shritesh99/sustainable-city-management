package gateway_service

import (
	"context"
	"log"

	db "github.com/Eytins/sustainable-city-management/backend/internal/db/sqlc"
	// "github.com/Eytins/sustainable-city-management/backend/internal/util"
)

func (server *GatewayService) CollectStationData() error {
	stationIds := []string{"@160051", "@5112", "@364333", "@101290", "@132820", "@22636", "@71989", "@80581", "@128077", "@106501", "@103711", "@77386", "@103714", "@354841", "@215515", "@43741", "@215914", "@354835"}
	for _, v := range stationIds {
		resp := server.CollectAirStationData(v)
		arg := db.CreateAirDataParams{
			Stationid: v,
			AirData:   resp,
		}
		_, err := server.store.CreateAirData(context.Background(), arg)
		if err != nil {
			log.Fatal(err)
		}
	}
	return nil
}
