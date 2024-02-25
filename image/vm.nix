{hostPkgs, ...}: {
  virtualisation.host.pkgs = hostPkgs;
  virtualisation.graphics = false;
  virtualisation. diskImage = null;
  virtualisation.cores = 4;
  virtualisation.memorySize = 4096;
}
