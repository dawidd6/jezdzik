package motor

type Motor struct {
	EnablePin   uint8 `yaml:"enable_pin"`
	ForwardPin  uint8 `yaml:"forward_pin"`
	BackwardPin uint8 `yaml:"backward_pin"`
}
