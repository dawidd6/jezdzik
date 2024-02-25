{buildGoModule, ...}:
buildGoModule {
  name = "jezdzik-app";
  src = ./.;
  vendorHash = "sha256-doUGUkpqlFfoxAEeUXLj6d89x0kNMcBBDLQQbLwuRdE=";
  CGO_ENABLED = 0;
}
