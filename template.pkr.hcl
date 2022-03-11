packer {
  required_plugins {
    arm-image = {
      version = "v0.2.6"
      source  = "github.com/dawidd6/arm-image"
    }
  }
}

source "arm-image" "ubuntu" {
  iso_url         = "http://cdimage.ubuntu.com/ubuntu-server/daily-preinstalled/current/jammy-preinstalled-server-armhf+raspi.img.xz"
  iso_checksum    = "file:http://cdimage.ubuntu.com/ubuntu-server/daily-preinstalled/current/SHA256SUMS"
  output_filename = "ubuntu.img"
  # 4GB
  target_image_size = 4294967296
}

build {
  sources = ["source.arm-image.ubuntu"]

  provisioner "ansible" {
    playbook_file = "ansible/playbook.yml"
    ansible_env_vars = [
      "ANSIBLE_FORCE_COLOR=1",
      "PYTHONUNBUFFERED=1",
    ]
    extra_arguments = [
      "-vvv",
      # The following arguments are required for running Ansible within a chroot
      # See https://www.packer.io/plugins/provisioners/ansible/ansible#chroot-communicator for details
      "--connection=chroot",
      #  Ansible needs this to find the mount path
      "-e ansible_host=${build.MountPath}",
      "-e packer=true"
    ]
  }
}
