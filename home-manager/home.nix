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
        stateVersion = "23.05";
        packages = with pkgs; [
            cabal-install
            cachix
            file
            gcc
            gh
            ghc
            git
            gnumake
            lesspipe
            niv
            shellcheck
            thefuck
            zlib
            haskellPackages.wai-app-static
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
            substituters = [ "https://cache.nixos.org" "https://cache.iog.io" "https://iohk.cachix.org" ] ++ private.nix.settings.substituters;
            trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo=" ] ++ private.nix.settings.trusted-public-keys;
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
