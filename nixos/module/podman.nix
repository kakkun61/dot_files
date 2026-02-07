# https://nixos.wiki/wiki/Podman
{
  virtualisation.containers.enable = true;
  virtualisation.podman.enable = true;

  # https://github.com/NixOS/nixpkgs/issues/385044#issuecomment-2682670249
  systemd.services."user@".serviceConfig.Delegate = "cpu cpuset io memory pids";
}
