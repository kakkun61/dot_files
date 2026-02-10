{
  services.openssh = {
    enable = true;
    extraConfig = ''
      AllowAgentForwarding yes
    '';
  };
}
