{ config, pkgs, ... }:

{
  home = {
    username = "kazuki";
    homeDirectory = /home/kazuki;
    stateVersion = "24.05";
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
      pinentry-tty
      pueue
      shellcheck
      stdenv
      wget
      zlib
      haskellPackages.haskell-language-server
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
      substituters = [
        "https://cache.nixos.org/"
        "https://cache.iog.io/"
        "https://iohk.cachix.org/"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
      ];
    };
  };

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
    gpg = {
      enable = true;
      publicKeys = [{ text = builtins.readFile ../gpg/public-key.txt; }];
    };
    tmux = {
      enable = true;
      extraConfig = builtins.readFile ../tmux/.tmux.conf;
    };
    home-manager.enable = true;
  };

  services = {
    gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-tty;
    };
  };
}
