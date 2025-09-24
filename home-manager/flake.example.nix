{
  description = "Home-manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dot-files = {
      url = "github:kakkun61/dot_files?dir=home-manager&ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, dot-files, ... }:
    let
      system = "x86_64-linux";
    in {
      homeConfigurations = {
        default = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          modules = [
            dot-files.homeModules.default
            # add some configs
            ./home.nix
          ];
        };
      };
    };
}
