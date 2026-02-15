{ description = "Nixpkgs overlay for Darling";

  inputs.nixpkgs.url = github:nixos/nixpkgs;

  nixConfig.extra-substituters = "https://nix-wrap.cachix.org";
  nixConfig.extra-trusted-public-keys = "nix-wrap.cachix.org-1:FcfSb7e+LmXBZE/MdaFWcs4bW2OQQeBnB/kgWlkZmYI=";

  outputs = { self, nixpkgs, flake-utils, ... }:
  flake-utils.lib.eachDefaultSystem
    (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (import ./overlays/darling.nix)
        ];
      };
    in {
      legacyPackages = pkgs;

      packages = {
        "darling" = pkgs.darling;
      };

      checks = {
        "darling" = nixpkgs.lib.nixos.runTest ./tests/darling.nix;
      };
    });
}
