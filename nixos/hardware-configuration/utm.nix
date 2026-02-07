# nix flake check を通すためのダミー
# TODO 本物に置きかえる
{
  fileSystems."/" = {
    device = "/dev/null";
  };
}
