{ secretPath, ... }:
{
  imports = [ ./secret.nix ];

  config = {
    services.k3s = {
      enable = true;
      extraFlags = [
        # Tailscale のネームサーバーを使わないようにするため
        "--resolv-conf ${../asset/resolv.conf}"
      ];
      tokenFile = "${secretPath}/k3s";
    };

    # K3s のドキュメントの指示
    # https://docs.k3s.io/ja/installation/requirements#オペレーティングシステム
    networking.firewall = {
      allowedTCPPorts = [ 6443 ];
      extraCommands = ''
        iptables -A INPUT -s 10.42.0.0/16 -j ACCEPT
        iptables -A INPUT -s 10.43.0.0/16 -j ACCEPT
      '';
      extraStopCommands = ''
        iptables -D INPUT -s 10.42.0.0/16 -j ACCEPT
        iptables -D INPUT -s 10.43.0.0/16 -j ACCEPT
      '';
    };
  };
}
