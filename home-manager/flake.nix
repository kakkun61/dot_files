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
      nixpkgs,
      flake-parts,
      home-manager,
      envar,
      treefmt-nix,
      git,
      ...
    }:
    let
      system = "x86_64-linux";
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        home-manager.flakeModules.home-manager
        treefmt-nix.flakeModule
      ];
      systems = [ system ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        let
          start-ssh-agent-wsl = pkgs.writeShellScriptBin "start-ssh-agent-wsl" ''
            SSH_AUTH_DIR="$(mktemp -d /tmp/ssh-auth.XXXX)"
            SSH_AUTH_SOCK="$SSH_AUTH_DIR/sock"
            setsid ${pkgs.socat} UNIX-LISTEN:"$SSH_AUTH_SOCK",fork EXEC:'npiperelay.exe -ei -v //./pipe/openssh-ssh-agent',nofork >>"$SSH_AUTH_DIR/log" 2>&1 &
            SSH_AUTH_PID=$!
            export SSH_AUTH_DIR
            export SSH_AUTH_SOCK
            export SSH_AUTH_PID
          '';
          stop-ssh-agent-wsl = pkgs.writeShellScriptBin "stop-ssh-agent-wsl" ''
            if [ -n "$SSH_AUTH_PID" ]
            then
                kill "$SSH_AUTH_PID"
                unset SSH_AUTH_PID
            fi
            if [ -n "$SSH_AUTH_DIR" ]
            then
                rm -r "$SSH_AUTH_DIR"
                unset SSH_AUTH_DIR
            fi
            if [ -n "$SSH_AUTH_SOCK" ]
            then
                unset SSH_AUTH_SOCK
            fi
          '';
        in
        {
          packages = {
            ssh-agent-wsl = pkgs.buildEnv {
              name = "ssh-agent-wsl";
              paths = [
                start-ssh-agent-wsl
                stop-ssh-agent-wsl
              ];
            };
          };
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              nixpkgs-fmt
            ];
          };
          treefmt = {
            programs.nixfmt.enable = true;
          };
        };
      flake = {
        homeModules = {
          default = import ./home.nix { inherit envar git; };
        };
      };
    };
}
