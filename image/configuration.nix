{
  modulesPath,
  lib,
  pkgs,
  hostPkgs,
  inputs,
  config,
  ...
}: let
  jezdzik-app =
    (hostPkgs.callPackage ../app/package.nix {})
    .overrideAttrs (old:
      old
      // {
        GOOS = "linux";
        GOARCH = "arm64";
      });
in {
  _module.args.jezdzik-app = jezdzik-app;

  imports = [(modulesPath + "/installer/sd-card/sd-image-aarch64.nix")];

  # Boot
  boot.enableContainers = false;
  boot.supportedFilesystems.zfs = lib.mkForce false;
  boot.tmp.useTmpfs = true;

  # Environment
  environment.systemPackages = with pkgs; [
    htop
    lm_sensors
  ];

  # Hardware
  hardware.enableRedistributableFirmware = true;

  # Networking
  networking.hostName = "jezdzik";
  networking.firewall.enable = false;
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = lib.mkForce [];
  networking.networkmanager.ensureProfiles.profiles = {
    jezdzik-hotspot = {
      connection = {
        id = "jezdzik-hotspot";
        type = "wifi";
        interface-name = "wlan0";
      };
      wifi = {
        band = "bg";
        channel = "1";
        mode = "ap";
        ssid = "jezdzik-hotspot";
      };
      wifi-security = {
        key-mgmt = "wpa-psk";
        psk = "wheeliegood";
      };
      ipv4 = {
        method = "shared";
      };
      ipv6 = {
        addr-gen-mode = "default";
        method = "ignore";
      };
    };
  };

  # Nix
  nix.registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
  nix.nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 1d";
  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.warn-dirty = false;

  # Nixpkgs
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-linux";

  # SD image
  sdImage.compressImage = false;
  sdImage.imageName = "jezdzik.img";

  # Services
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";

  # System
  system.stateVersion = "24.05";

  # Systemd
  systemd.services.jezdzik-app = {
    description = "jezdzik-app";
    wantedBy = ["default.target"];
    serviceConfig = {
      ExecStart = "${jezdzik-app}/bin/linux_arm64/jezdzik-app";
      Restart = "always";
      Type = "simple";

      #WorkingDirectory = "/";
    };
  };

  # Users
  users.users.root.password = "superusmaximus";

  # Virtualisation
  virtualisation.vmVariant = import ./vm.nix {inherit hostPkgs;};
}
