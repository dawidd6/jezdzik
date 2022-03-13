# Jeździk

This is a repository holding all necessary code, scripts, etc for my remote controlled vehicle.

## Ingredients

- Raspberry Pi 2 B
- Netis WF2120 Wi-Fi Adapter
- LEGO Excavator set
- ...

## Getting started

1. Copy `group_vars/all.yml` file to `host_vars/default.yml` in `ansible` directory and fill it with appropriate values.
1. Build the image with packer, execute as **root**:

    ```
    packer init template.pkr.hcl
    packer build template.pkr.hcl
    ```

1. Flash built image onto SD card and plug it in to Raspberry Pi and power on.

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
