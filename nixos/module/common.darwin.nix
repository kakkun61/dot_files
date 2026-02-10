# ./common.nix で必要になる引数（ここでは pkgs）を明示する必要がある
#
# See https://flake.parts/module-arguments#how-module-function-arguments-work
#
# > The Nix module system determines which arguments to pass to a module
# > function by using builtins.functionArgs. This means only the parameters you
# > explicitly name in your function signature will be available.
args@{ pkgs, ... }:
let
  common = import ./common.nix args;
in
{
  config = {
    nix.settings = {
      # nixos では [ "nix-command" "flakes" ] でいけるのに、nix-darwin ではダメらしい
      experimental-features = "nix-command flakes";
      trusted-users = [
        "root"
        "@admin"
      ];
    };

    nixpkgs = {
      hostPlatform = "aarch64-darwin";
      config.allowUnfree = true;
    };

    time = common.config.time;

    users.users.kazuki = {
      gid = "admin";
      createHome = true;
      home = "/Users/kazuki";
      openssh = common.config.users.users.kazuki.openssh;
      packages = common.config.users.users.kazuki.packages;
      shell = common.config.users.defaultUserShell;
    };

    security.pam.services.sudo_local.touchIdAuth = true;
  };
}
