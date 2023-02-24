package util

import "log"

func LogFatal (msg string, err error) {
	if err != nil {
		log.Fatal(msg, err)
	}
}