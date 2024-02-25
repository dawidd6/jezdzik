{
  writeShellApplication,
  pv,
  ...
}:
writeShellApplication {
  name = "flash";
  text = ''
    sudo bash -c "${pv}/bin/pv --sync < result/sd-image/jezdzik.img > $1"
  '';
}
