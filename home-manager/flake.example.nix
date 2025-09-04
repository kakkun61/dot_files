{
  description = "Home-manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dot-files = {
      url = "github:kakkun61/dot_files?dir=home-manager&ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  outputs = inputs@{ nixpkgs, flake-parts, home-manager, dot-files, ... }:
    let
      system = "x86_64-linux";
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        home-manager.flakeModules.home-manager
        # add some options
      ];
      systems = [ system ];
      flake = {
        homeConfigurations = {
          default = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
            modules = [
              dot-files.homeModules.default
              # add some configs
            ];
          };
        };
      };
    };
}
