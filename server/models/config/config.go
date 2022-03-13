package config

import (
	"github.com/dawidd6/jezdzik/server/models/motor"
)

type Motors struct {
}

type Config struct {
	Motors struct {
		Left  *motor.Motor `yaml:"left"`
		Right *motor.Motor `yaml:"right"`
	} `yaml:"motors"`
}
