{ pkgs, secretPath, ... }:
{
  imports = [ ./secret.nix ];
  config = {
    systemd.services.cloudflare-tunnel-home = {
      description = "Cloudflare Tunnel for My Home";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        RuntimeDirectory = "cloudflared-tunnel-home";
        RuntimeDirectoryMode = "0400";
        LoadCredential = [ "token:${secretPath}/cloudflare/tunnel/home" ];
        ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run";
        Restart = "on-failure";
        DynamicUser = true;
      };
      environment = {
        TUNNEL_TOKEN_FILE = "%d/token";
      };
    };
  };
}
