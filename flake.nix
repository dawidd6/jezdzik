{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, ...} @ inputs: let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs {
      inherit system;
    };
  in {
    nixosConfigurations.jezdzik = inputs.nixpkgs.lib.nixosSystem {
      modules = [./image/configuration.nix];
      specialArgs = {
        inherit inputs;
        hostPkgs = pkgs;
      };
    };
    packages.${system} = {
      inherit (self.nixosConfigurations.jezdzik.config.system.build) sdImage vm;
      app = pkgs.callPackage ./app/package.nix {};
      flash = pkgs.callPackage ./image/flash.nix {};
      deploy = pkgs.callPackage ./image/deploy.nix {};
    };
    devShells.${system} = {
      default = pkgs.mkShell {
        packages = [
          pkgs.go
        ];
        shellHook = ''
          ${self.checks.${system}.pre-commit.shellHook}
        '';
      };
    };
    checks.${system} =
      self.packages.${system}
      // {
        pre-commit = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks.treefmt.enable = true;
          hooks.treefmt.packageOverrides.treefmt = self.formatter.${system};
        };
      };
    formatter.${system} = inputs.treefmt.lib.mkWrapper pkgs {
      projectRootFile = "flake.nix";
      programs.alejandra.enable = true;
      programs.deadnix.enable = true;
      programs.gofmt.enable = true;
      programs.hclfmt.enable = true;
      programs.prettier.enable = true;
      programs.statix.enable = true;
    };
  };
}
