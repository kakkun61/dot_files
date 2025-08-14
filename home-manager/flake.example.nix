{
  description = "Home-manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Replace this with the actual path
    # or use --override-input
    dot-files.url = "path:./.";
  };

  outputs = inputs@{ nixpkgs, flake-parts, home-manager, dot-files, ... }:
    let
      system = "x86_64-linux";
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        home-manager.flakeModules.home-manager
      ];
      systems = [ system ];
      flake = {
        homeConfigurations = {
          default = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs { inherit system; };
            modules = [
              dot-files.homeModules.default
              ./private.nix
            ];
          };
        };
      };
    };
}
