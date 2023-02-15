package main

import (
	_ "github.com/lib/pq"

	"database/sql"
	"tcd.ie/ase/group7/sustainablecity/apiservice"
	db "tcd.ie/ase/group7/sustainablecity/db/sqlc"
	"tcd.ie/ase/group7/sustainablecity/util"
)

func main() {
	config, err := util.LoadConifg(".")
	util.LogFatal("cannot load conf:", err)

	conn, err := sql.Open(config.DBDriver, config.DBSource)
	util.LogFatal("cannot connect to db:", err)

	store := db.NewStore(conn)
	server := apiservice.NewServer(store)

	err = server.Start(config.Port)
	util.LogFatal("cannot start server:", err)
}
