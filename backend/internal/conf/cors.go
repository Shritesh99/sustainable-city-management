package conf

import (
	"github.com/gofiber/fiber/v2/middleware/cors"
)

func GetCorsConf() cors.Config {
	configDefault := cors.Config{
		Next:             nil,
		AllowOrigins:     "*",
		AllowMethods:     "GET,POST,HEAD,PUT,DELETE,PATCH",
		AllowHeaders:     "Origin,Content-Type,Accept,Content-Length,Accept-Language,Accept-Encoding,Connection,Access-Control-Allow-Origin,Token",
		AllowCredentials: true,
		ExposeHeaders:    "",
		MaxAge:           0,
	}

	return configDefault
}
