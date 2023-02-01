{ config, pkgs, ... }:

{
    home = {
        username = builtins.getEnv "USER";
        homeDirectory = builtins.getEnv "HOME";
        stateVersion = "22.11";
        packages = with pkgs; [
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
        };
    };

    programs = {
        bash = {
            enable = true;
            profileExtra = "";
            initExtra = "";
            logoutExtra = "";
        };
        direnv = {
            enable = true;
            nix-direnv.enable = true;
        };
        git = {
            enable = true;
            userEmail = "kazuki.okamoto@kakkun61.com";
            userName = "Kazuki Okamoto";
        };
        home-manager.enable = true;
    };
}
