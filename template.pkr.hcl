source "arm-image" "ubuntu" {
  iso_url         = "http://cdimage.ubuntu.com/releases/20.04/release/ubuntu-20.04.4-preinstalled-server-armhf+raspi.img.xz"
  iso_checksum    = "3b1704e8e4ff8e01dd89b9dd6adf9b99b48b2a7530d6f7676ce8c37772ff4178"
  output_filename = "ubuntu-20.04.img"
  # Source image is 1.7GB, so make target image 2.5GB
  target_image_size = 2684354560
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
      "-e ansible_host=${build.MountPath}"
    ]
  }
}
