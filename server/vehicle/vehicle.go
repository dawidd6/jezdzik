package vehicle

import (
	"github.com/dawidd6/jezdzik/server/config"
	"github.com/dawidd6/jezdzik/server/motor"
	"github.com/stianeikeland/go-rpio"
)

type Vehicle struct {
	left  *motor.Motor
	right *motor.Motor
}

func New(cfg *config.Config) *Vehicle {
	return &Vehicle{
		left:  cfg.Motors.Left,
		right: cfg.Motors.Right,
	}
}

func (v *Vehicle) Init() {
	rpio.PinMode(rpio.Pin(v.left.EnablePin), rpio.Output)
	rpio.PinMode(rpio.Pin(v.left.ForwardPin), rpio.Output)
	rpio.PinMode(rpio.Pin(v.left.BackwardPin), rpio.Output)
	rpio.PinMode(rpio.Pin(v.right.EnablePin), rpio.Output)
	rpio.PinMode(rpio.Pin(v.right.ForwardPin), rpio.Output)
	rpio.PinMode(rpio.Pin(v.right.BackwardPin), rpio.Output)
}

func (v *Vehicle) Enable() {
	rpio.WritePin(rpio.Pin(v.left.EnablePin), rpio.High)
	rpio.WritePin(rpio.Pin(v.right.EnablePin), rpio.High)
}

func (v *Vehicle) Disable() {
	rpio.WritePin(rpio.Pin(v.left.EnablePin), rpio.Low)
	rpio.WritePin(rpio.Pin(v.right.EnablePin), rpio.Low)
}

func (v *Vehicle) Forward() {
	rpio.WritePin(rpio.Pin(v.left.ForwardPin), rpio.Low)
	rpio.WritePin(rpio.Pin(v.left.BackwardPin), rpio.High)
	rpio.WritePin(rpio.Pin(v.right.ForwardPin), rpio.Low)
	rpio.WritePin(rpio.Pin(v.right.BackwardPin), rpio.High)
}

func (v *Vehicle) Backward() {
	rpio.WritePin(rpio.Pin(v.left.ForwardPin), rpio.High)
	rpio.WritePin(rpio.Pin(v.left.BackwardPin), rpio.Low)
	rpio.WritePin(rpio.Pin(v.right.ForwardPin), rpio.High)
	rpio.WritePin(rpio.Pin(v.right.BackwardPin), rpio.Low)
}

func (v *Vehicle) Left() {
	rpio.WritePin(rpio.Pin(v.left.ForwardPin), rpio.Low)
	rpio.WritePin(rpio.Pin(v.left.BackwardPin), rpio.High)
	rpio.WritePin(rpio.Pin(v.right.ForwardPin), rpio.High)
	rpio.WritePin(rpio.Pin(v.right.BackwardPin), rpio.Low)
}

func (v *Vehicle) Right() {
	rpio.WritePin(rpio.Pin(v.left.ForwardPin), rpio.High)
	rpio.WritePin(rpio.Pin(v.left.BackwardPin), rpio.Low)
	rpio.WritePin(rpio.Pin(v.right.ForwardPin), rpio.Low)
	rpio.WritePin(rpio.Pin(v.right.BackwardPin), rpio.High)
}

func (v *Vehicle) Stop() {
	rpio.WritePin(rpio.Pin(v.left.ForwardPin), rpio.Low)
	rpio.WritePin(rpio.Pin(v.left.BackwardPin), rpio.Low)
	rpio.WritePin(rpio.Pin(v.right.ForwardPin), rpio.Low)
	rpio.WritePin(rpio.Pin(v.right.BackwardPin), rpio.Low)
}
