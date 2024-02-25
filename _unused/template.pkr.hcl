variable "wifi_ssid" {
  type        = string
  description = "WiFi access point SSID"
}

variable "wifi_pass" {
  type        = string
  description = "WiFi password"
  sensitive   = true
}

variable "ssh_pubkey" {
  type        = string
  description = "SSH public key, will be added to resulting image"
}

packer {
  required_plugins {
    arm-image = {
      version = "= 0.2.7"
      source  = "github.com/solo-io/arm-image"
    }
  }
}

source "arm-image" "os" {
  iso_url         = "https://downloads.raspberrypi.com/raspios_lite_armhf/images/raspios_lite_armhf-2023-12-11/2023-12-11-raspios-bookworm-armhf-lite.img.xz"
  iso_checksum    = "sha256:5df1850573c5e1418f70285c96deea2cfa87105cca976262f023c49b31cdd52b"
  output_filename = "jezdzik.img"
}

build {
  sources = ["source.arm-image.os"]

  provisioner "file" {
    source      = "app/jezdzik"
    destination = "/jezdzik"
  }

  provisioner "shell" {
    env    = var
    script = "provision.sh"
  }
}
