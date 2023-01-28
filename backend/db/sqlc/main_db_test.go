package db

import (
	"database/sql"
	"os"
	"testing"

	_ "github.com/lib/pq"
	"tcd.ie/ase/group7/sustainablecity/util"
)

var testQueries *Queries
var testDB *sql.DB

func TestMain(m *testing.M) {
	config, err := util.LoadConifg("../../")
	util.LogFatal("cannot load config:", err)

	testDB, err = sql.Open(config.DBDriver, config.DBSource)
	util.LogFatal("cannot connect to db:", err)

	testQueries = New(testDB)

	os.Exit(m.Run())
}