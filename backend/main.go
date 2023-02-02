package main

import (
	"log"

	"tcd.ie/ase/group7/sustainablecity/apiservice"
	"tcd.ie/ase/group7/sustainablecity/util"
)

func main() {
	config, err := util.LoadConifg(".")
	if err != nil {
		log.Fatal("cannot load config:", err)
	}

	server := apiservice.NewServer()
	err = server.Start(config.Port)
	if err != nil {
		log.Fatal("cannot start server:", err)
	}
}