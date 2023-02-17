{ config, pkgs, ... }:

let
    bash-profile = "";
    bash-init = "";
    bash-logout = "";
    gpg-public-key = "";
    tmux-config = "";
    private = import ./private.nix;
in
{
    home = {
        username = builtins.getEnv "USER";
        homeDirectory = builtins.getEnv "HOME";
        stateVersion = "22.11";
        packages = with pkgs; [
            cachix
            file
            gh
            git
            gnumake
            lesspipe
            shellcheck
            thefuck
        ];
    };

    nix = {
        package = pkgs.nix;
        settings = {
            experimental-features = [ "nix-command" "flakes" ];
            keep-derivations = true;
            keep-outputs = true;
            netrc-file = "${config.home.homeDirectory}/.netrc";
            access-tokens = private.nix.settings.access-tokens;
        };
    };

    programs = {
        bash = {
            enable = true;
            profileExtra = bash-profile;
            initExtra = bash-init;
            logoutExtra = bash-logout;
        };
        direnv = {
            enable = true;
            nix-direnv.enable = true;
        };
        gpg = {
            enable = true;
            publicKeys = [ { text = gpg-public-key; } ];
        };
        tmux = {
            enable = true;
            extraConfig = tmux-config;
        };
        home-manager.enable = true;
    };

    services = {
        gpg-agent = {
            enable = true;
        };
    };
}
