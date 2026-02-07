{ nixos-wsl }:
{ ... }:
{
  imports = [ nixos-wsl.nixosModules.default ];
  config = {
    wsl = {
      enable = true;
      defaultUser = "kazuki";
      interop.includePath = false;
      usbip.enable = true;
      wslConf = {
        interop.appendWindowsPath = false;
        user.default = "kazuki";
      };
    };
  };
}
