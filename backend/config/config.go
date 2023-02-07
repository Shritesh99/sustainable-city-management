package config

import (
	"flag"
	"os"
	"sustinable-city-management/pkg/constants"
	"sustinable-city-management/pkg/logger"
	"sustinable-city-management/pkg/probes"

	"github.com/pkg/errors"
	"github.com/spf13/viper"
)

type Config struct {
	ServiceName string           `mapstructure:"serviceName"`
	Logger      logger.LogConfig `mapstructure:"logger"`
	GRPC        GRPC             `mapstructure:"grpc"`
	Timeouts    Timeouts         `mapstructure:"timeouts" validate:"required"`
	Http        Http             `mapstructure:"http"`
	Probes      probes.Config    `mapstructure:"probes"`
}
type GRPC struct {
	Port        string `mapstructure:"port"`
	Development bool   `mapstructure:"development"`
}
type Http struct {
	Port                string   `mapstructure:"port" validate:"required"`
	Development         bool     `mapstructure:"development"`
	BasePath            string   `mapstructure:"basePath" validate:"required"`
	ProductsPath        string   `mapstructure:"productsPath" validate:"required"`
	DebugErrorsResponse bool     `mapstructure:"debugErrorsResponse"`
	IgnoreLogUrls       []string `mapstructure:"ignoreLogUrls"`
}
type HTTP struct {
	Port                string   `mapstructure:"port" validate:"required"`
	Development         bool     `mapstructure:"development"`
	BasePath            string   `mapstructure:"basePath" validate:"required"`
	ProductsPath        string   `mapstructure:"productsPath" validate:"required"`
	DebugErrorsResponse bool     `mapstructure:"debugErrorsResponse"`
	IgnoreLogUrls       []string `mapstructure:"ignoreLogUrls"`
}
type Timeouts struct {
	PostgresInitMilliseconds int  `mapstructure:"postgresInitMilliseconds" validate:"required"`
	PostgresInitRetryCount   uint `mapstructure:"postgresInitRetryCount" validate:"required"`
}

var configPath string

func init() {
	flag.StringVar(&configPath, "config", "", "Search microservice config path")
}
func InitConfig() (*Config, error) {
	if configPath == "" {
		configPathFromEnv := os.Getenv(constants.ConfigPath)
		if configPathFromEnv != "" {
			configPath = configPathFromEnv
		}
	}
	cfg := &Config{}

	viper.SetConfigType(constants.Yaml)
	viper.SetConfigFile(configPath)
	if err := viper.ReadInConfig(); err != nil {
		return nil, errors.Wrap(err, "viper.ReadInConfig")
	}

	if err := viper.Unmarshal(cfg); err != nil {
		return nil, errors.Wrap(err, "viper.Unmarshal")
	}
	grpcPort := os.Getenv(constants.GrpcPort)
	if grpcPort != "" {
		cfg.GRPC.Port = grpcPort
	}
	return cfg, nil
}
