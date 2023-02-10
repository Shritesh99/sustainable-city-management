package common_service

import (
	"fmt"
	"strings"
	"time"

	"github.com/Eytins/sustainable-city-management/backend/config"
)

func GetMicroserviceName(cfg *config.Config) string {
	return fmt.Sprintf("(%s)", strings.ToUpper(cfg.ServiceName))
}

func (a *service) waitShootDown(duration time.Duration) {
	go func() {
		time.Sleep(duration)
		a.doneCh <- struct{}{}
	}()
}
