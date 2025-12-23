{
  description = "Home-manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dot-files = {
      url = "github:kakkun61/dot_files";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      dot-files,
      ...
    }:
    let
      system =
        # select your system
        # "aarch64-darwin";
        "x86_64-linux";
    in
    {
      homeConfigurations = {
        kazuki = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          modules = [
            dot-files.homeModules.default
            { home.stateVersion = "24.05"; }
            # add some configs
            ./home.nix
          ];
        };
      };
    };
}
