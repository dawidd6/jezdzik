# Jeździk

This is a repository holding all necessary code, scripts, etc for my remote controlled vehicle named _"Jeździk"_ (by my GF).

## Ingredients

### Hardware

- LEGO 42006 _"Excavator"_ set
  - used for building the construction of vehicle
- LEGO 8882 PF XL motor x2
  - used for moving caterpillars of vehicle
- LEGO 8881 PF battery box
  - used for powering the motors
- Powerbank 10000mAh
  - used for powering the Raspberry Pi
- Raspberry Pi 2 B
  - used for control of the vehicle
- Wi-Fi adapter
  - used for connecting server with client
- L293D motor driver
  - used for driving the motors
- Solderless breadboard
  - used for connecting electronics
- Some female-male connecting cables
  - used for connecting electronics

### Software

- Ubuntu
  - operating system for Raspberry Pi
- Packer
  - builder of operating system image
- Ansible
  - provisioner of operating system image
- Go
  - server code
- Flutter
  - client code

## GPIO

```yaml
motors:
  right:
    enable_pin: 12
    forward_pin: 17
    backward_pin: 27
  left:
    enable_pin: 13
    forward_pin: 24
    backward_pin: 23
```

## Thanks

Credits for inspiration goes to author of [this article](https://www.raspberry-pi-geek.com/Archive/2014/06/Using-Legos-to-turn-a-Raspberry-Pi-into-a-mobile-device)
