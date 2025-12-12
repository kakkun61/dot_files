{ envar, git }:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  jsonFormat = pkgs.formats.json { };
in
{
  imports = [ envar.homeModules.default ];

  config = {
    home = {
      username = "kazuki";
      homeDirectory = if pkgs.system == "aarch64-darwin" then "/Users/kazuki" else "/home/kazuki";
      packages = with pkgs; [
        cabal-install
        cachix
        file
        gcc
        ghc
        gnumake
        lesspipe
        pinentry-tty
        pueue
        ricty
        shellcheck
        stdenv
        wget
        zlib
        haskellPackages.haskell-language-server
        haskellPackages.wai-app-static
      ];
    };

    xdg.configFile = lib.mkIf (pkgs.stdenv.hostPlatform.system == "aarch64-darwin") {
      "karabiner/karabiner.json".source = jsonFormat.generate "karabiner.json" {
        profiles = [
          {
            complex_modifications = {
              rules = [
                {
                  description = "AquaSKK for Terminal/iTerm2";
                  manipulators = [
                    {
                      conditions = [
                        {
                          bundle_identifiers = [
                            "^com\\.googlecode\\.iterm2"
                            "^com\\.apple\\.Terminal"
                          ];
                          type = "frontmost_application_if";
                        }
                      ];
                      from = {
                        key_code = "j";
                        modifiers = {
                          mandatory = [ "left_control" ];
                        };
                      };
                      to = [
                        {
                          key_code = "j";
                          modifiers = [
                            "left_control"
                            "left_shift"
                          ];
                        }
                      ];
                      type = "basic";
                    }
                  ];
                }
                {
                  description = "Shift and Space";
                  manipulators = [
                    {
                      from = {
                        key_code = "spacebar";
                        modifiers = {
                          optional = [ "any" ];
                        };
                      };
                      to = [ { key_code = "left_shift"; } ];
                      to_if_alone = [ { key_code = "spacebar"; } ];
                      type = "basic";
                    }
                  ];
                }
              ];
            };
            devices = [
              {
                identifiers = {
                  is_keyboard = true;
                  product_id = 641;
                  vendor_id = 1452;
                };
                simple_modifications = [
                  {
                    from = {
                      key_code = "caps_lock";
                    };
                    to = [ { key_code = "left_control"; } ];
                  }
                  {
                    from = {
                      key_code = "left_command";
                    };
                    to = [ { key_code = "left_shift"; } ];
                  }
                  {
                    from = {
                      key_code = "left_control";
                    };
                    to = [ { key_code = "launchpad"; } ];
                  }
                  {
                    from = {
                      key_code = "left_shift";
                    };
                    to = [ { key_code = "left_command"; } ];
                  }
                ];
              }
            ];
            name = "Default";
            selected = true;
            virtual_hid_keyboard = {
              keyboard_type_v2 = "ansi";
            };
          }
          {
            name = "Normal";
            virtual_hid_keyboard = {
              keyboard_type_v2 = "ansi";
            };
          }
        ];
      };
    };

    nix = {
      package = pkgs.nix;
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
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
        historyControl = [ "ignoreboth" ];
        initExtra = ''
          set -o ignoreeof

          source "${config.programs.git.package}/share/bash-completion/completions/git-prompt.sh"
          # 手動で設定しなくていい？
          # source "${git}/contrib/completion/git-completion.bash"
          # source "${config.services.pueue.package}/share/bash-completion/completions/pueue.bash"

          if type __git_ps1 > /dev/null 2>&1
          then
              PS1='\[\e]0;\w\a\]\e[34m($?)\e[0m\n\[\e[32m\]\u@\h [$SHLVL] \[\e[33m\]\w\[\e[0m\]\[\e[36m\]`__git_ps1 " %s"`\[\e[0m\]\n\$ '
          else
              PS1='\[\e]0;\w\a\]\e[34m($?)\e[0m\n\[\e[32m\]\u@\h [$SHLVL] \[\e[33m\]\w\[\e[0m\]\n\$ '
          fi
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
        ];
      };
      diff-highlight = {
        enable = true;
        enableGitIntegration = true;
      };
      direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
        config = {
          global.warn_timeout = 0;
        };
      };
      envar = {
        enable = true;
        enableBashIntegration = true;
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
        ignores = [
          ".DS_Store"
          "*~"
          "Thumbs.db"
        ];
        signing = {
          key = "C37B19CBD6166EFF";
          signByDefault = true;
        };
        settings = {
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
          user = {
            email = "kazuki.okamoto@kakkun61.com";
            name = "Kazuki Okamoto (岡本和樹)";
          };
        };
      };
      gpg = {
        enable = true;
        publicKeys = [ { text = builtins.readFile ./gpg.pub.asc; } ];
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
        enableBashIntegration = true;
        defaultCacheTtl = 7200;
        pinentry.package = pkgs.pinentry-tty;
      };
      pueue.enable = true;
      ssh-agent.enable = pkgs.system != "aarch64-darwin";
    };
  };
}
