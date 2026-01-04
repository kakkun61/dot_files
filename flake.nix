{
  description = "This gives an environment to develop home.nix and provides it";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    envar = {
      url = "github:kakkun61/envar";
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
      envar,
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
          inherit envar git;
          root = ./.;
        };
        templates.default = import ./home-manager/template.nix;
        # ファイル生成用・テスト用の設定
        homeConfigurations.test = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          modules = [
            self.homeModules.default
            { home.stateVersion = "25.11"; }
          ];
        };
      };
    };
}
