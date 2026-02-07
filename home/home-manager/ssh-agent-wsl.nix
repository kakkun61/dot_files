{ pkgs }:
let
  start-ssh-agent-wsl = pkgs.writeShellScriptBin "start-ssh-agent-wsl" ''
    SSH_AUTH_DIR="$(mktemp -d /tmp/ssh-auth.XXXX)"
    SSH_AUTH_SOCK="$SSH_AUTH_DIR/sock"
    setsid ${pkgs.socat} UNIX-LISTEN:"$SSH_AUTH_SOCK",fork EXEC:'npiperelay.exe -ei -v //./pipe/openssh-ssh-agent',nofork >>"$SSH_AUTH_DIR/log" 2>&1 &
    SSH_AUTH_PID=$!
    export SSH_AUTH_DIR
    export SSH_AUTH_SOCK
    export SSH_AUTH_PID
  '';
  stop-ssh-agent-wsl = pkgs.writeShellScriptBin "stop-ssh-agent-wsl" ''
    if [ -n "$SSH_AUTH_PID" ]
    then
        kill "$SSH_AUTH_PID"
        unset SSH_AUTH_PID
    fi
    if [ -n "$SSH_AUTH_DIR" ]
    then
        rm -r "$SSH_AUTH_DIR"
        unset SSH_AUTH_DIR
    fi
    if [ -n "$SSH_AUTH_SOCK" ]
    then
        unset SSH_AUTH_SOCK
    fi
  '';
in
pkgs.buildEnv {
  name = "ssh-agent-wsl";
  paths = [
    start-ssh-agent-wsl
    stop-ssh-agent-wsl
  ];
}
