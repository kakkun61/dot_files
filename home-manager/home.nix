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
    bash = {
      enable = true;
      historyControl = ["ignoreboth"];
      initExtra = ''
        source "${config.programs.git.package}/share/bash-completion/completions/git-prompt.sh"
        source "${config.programs.git.package}/contrib/completion/git-completion.bash"
        source "${config.services.pueue.package}/completions/bash/pueue.bash"
      '';
      sessionVariables = {
        GIT_PS1_SHOWDIRTYSTATE = 1;
      };
      shellAliases = {
        ls = "ls --color=auto";
        shellcheck = "shellcheck --color=always";
      };
      shellOptions = [
        "histappend"
        "checkwinsize"
        "extglob"
        "globstar"
        "checkjobs"
        "ignoreeof"
      ];
    };
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
    gh = {
      enable = true;
      extensions = [
        pkgs.gh-copilot
      ];
      gitCredentialHelper.enable = true;
    };
    git = {
      enable = true;
      diff-highlight.enable = true;
      ignores = [
        ".DS_Store"
        "*~"
        "Thumbs.db"
      ];
      signing = {
        key = "C37B19CBD6166EFF";
        signByDefault = true;
      };
      userEmail = "kazuki.okamoto@kakkun61.com";
      userName = "Kazuki Okamoto (岡本和樹)";
      extraConfig = {
        color.ui = "auto";
        core = {
          editor = "nano";
          eof = "lf";
          autocrlf = false;
        };
        help.autocorrect = 1;
        init.defaultBranch = "master";
        merge.conflictStyle = "diff3";
        pull.ff = "only";
        push.default = "upstream";
      };
    };
    gpg = {
      enable = true;
      publicKeys = [{ text = builtins.readFile ../gpg/public-key.txt; }];
    };
    home-manager.enable = true;
    ssh = {
      enable = true;
      enableDefaultConfig = false;
    };
    tmux = {
      enable = true;
      baseIndex = 1;
      mouse = true;
      prefix = "C-t";
      terminal = "screen-256color";
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-tty;
    };
    pueue.enable = true;
  };
}
