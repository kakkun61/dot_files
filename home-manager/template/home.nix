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
        # ricty
      ];
    };
  };
}
