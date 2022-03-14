package config_test

import (
	"testing"

	"github.com/dawidd6/jezdzik/server/config"
	"github.com/stretchr/testify/assert"
	"gopkg.in/yaml.v2"
)

const in = `
motors:
  left:
    enable_pin: 1
    forward_pin: 2
    backward_pin: 3
  right:
    enable_pin: 4
    forward_pin: 5
    backward_pin: 6
`

func TestYAML(t *testing.T) {
	cfg := &config.Config{}

	err := yaml.Unmarshal([]byte(in), cfg)
	assert.NoError(t, err)

	out, err := yaml.Marshal(cfg)
	assert.NoError(t, err)

	assert.YAMLEq(t, in, string(out))
}
