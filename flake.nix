{
  description = "This gives an environment to develop home.nix and provides it";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git = {
      url = "git+https://github.com/git/git";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      home-manager,
      treefmt-nix,
      git,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        home-manager.flakeModules.home-manager
        treefmt-nix.flakeModule
      ];
      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem =
        {
          pkgs,
          ...
        }:
        {
          packages.ssh-agent-wsl = import ./home-manager/ssh-agent-wsl.nix { inherit pkgs; };
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [ cspell ];
          };
          treefmt = {
            programs = {
              jsonfmt.enable = true;
              nixfmt.enable = true;
            };
          };
        };
      flake = {
        homeModules.default = import ./home-manager/home.nix {
          inherit git;
          root = ./.;
        };
        templates.default = import ./home-manager/template.nix;
        homeConfigurations =
          let
            mkTestConfiguration =
              system:
              home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs {
                  inherit system;
                  config.allowUnfree = true;
                };
                modules = [
                  self.homeModules.default
                  { home.stateVersion = "25.11"; }
                ];
              };
          in
          {
            gmk = home-manager.lib.homeManagerConfiguration {
              pkgs = import nixpkgs {
                system = "x86_64-linux";
                config.allowUnfree = true;
              };
              modules = [
                self.homeModules.default
                ./home-manager/configuration/gmk.nix
                { home.stateVersion = "25.05"; }
              ];
            };
            surface-wsl = home-manager.lib.homeManagerConfiguration {
              pkgs = import nixpkgs {
                system = "x86_64-linux";
                config.allowUnfree = true;
              };
              modules = [
                self.homeModules.default
                ./home-manager/configuration/surface-wsl.nix
                { home.stateVersion = "24.05"; }
              ];
            };
            # ファイル生成用・テスト用の設定
            test-x86_64-linux = mkTestConfiguration "x86_64-linux";
            test-aarch64-darwin = mkTestConfiguration "aarch64-darwin";
          };
      };
    };
}
