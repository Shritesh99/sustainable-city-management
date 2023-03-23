package config

import (
	"flag"
	"fmt"
	"os"

	"github.com/Eytins/sustainable-city-management/backend/pkg/constants"
	"github.com/Eytins/sustainable-city-management/backend/pkg/logger"
	"github.com/Eytins/sustainable-city-management/backend/pkg/probes"

	"github.com/pkg/errors"
	"github.com/spf13/viper"
)

type Config struct {
	ServiceName         string           `mapstructure:"serviceName"`
	ServiceType         string           `mapstructure:"serviceType"`
	ServiceUrl          string           `mapstructure:"serviceUrl"`
	Logger              logger.LogConfig `mapstructure:"logger"`
	GRPC                GRPC             `mapstructure:"grpc"`
	Timeouts            Timeouts         `mapstructure:"timeouts" validate:"required"`
	Http                Http             `mapstructure:"http"`
	Probes              probes.Config    `mapstructure:"probes"`
	ConnectedServices   []Services       `mapstructure:"ConnectedServices"`
	Honeybadger_API_KEY string           `mapstructure:"Honeybadger_API_KEY"`
	Development         bool             `mapstructure:"development"`
	DB                  DB               `mapstructure:"db"`
}
type Services struct {
	ServiceName     string `mapstructure:"serviceName"`
	ServiceType     string `mapstructure:"serviceType"`
	ServiceUrl      string `mapstructure:"serviceUrl"`
	HealthcheckPort string `mapstructure:"healthcheckPort"`
	HttpPort        string `mapstructure:"httpPort"`
	GrpcPort        string `mapstructure:"grpcPort"`
}
type GRPC struct {
	Port        string `mapstructure:"port"`
	Development bool   `mapstructure:"development"`
}
type Http struct {
	Port                string   `mapstructure:"port" validate:"required"`
	Development         bool     `mapstructure:"development"`
	DebugErrorsResponse bool     `mapstructure:"debugErrorsResponse"`
	IgnoreLogUrls       []string `mapstructure:"ignoreLogUrls"`
}

type Timeouts struct {
	PostgresInitMilliseconds int  `mapstructure:"postgresInitMilliseconds" validate:"required"`
	PostgresInitRetryCount   uint `mapstructure:"postgresInitRetryCount" validate:"required"`
}

type DB struct {
	DB_SOURCE string `mapstructure:"DB_SOURCE"`
	DB_DRIVER string `mapstructure:"DB_DRIVER"`
	AIR_TOKEN string `mapstructure:"AIR_TOKEN"`
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
		} else {
			getwd, err := os.Getwd()
			if err != nil {
				return nil, errors.Wrap(err, "os.Getwd")
			}
			configPath = fmt.Sprintf("%s/config/config1.yaml", getwd)
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
