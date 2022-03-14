# Jeździk

This is a repository holding all necessary code, scripts, etc for my remote controlled vehicle named "_Jeździk_" (by my GF).

## Ingredients

### Hardware

- LEGO 42006 "_Excavator_" set
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

### Right motor

GPIO12 GPIO17 GPIO27 direction
1      1      0      forward
1      0      1      backward
1      1      1      stop
1      0      0      stop
0      x      x      stop

### Left motor

GPIO13 GPIO23 GPIO24 direction
1      0      1      forward
1      1      0      backward
1      1      1      stop
1      0      0      stop
0      x      x      stop
