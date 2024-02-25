{
  writeShellApplication,
  nixos-rebuild,
  ...
}:
writeShellApplication {
  name = "deploy";
  text = ''
    ${nixos-rebuild}/bin/nixos-rebuild "''${1:-switch}" --flake .#jezdzik --target-host root@jezdzik
  '';
}
