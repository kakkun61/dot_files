{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [ ];

  config = {
    home = {
      packages = with pkgs; [
        btop
        kubernetes-helm
      ];
      sessionPath = [
        "$HOME/.local/bin"
      ];
    };
  };
}
