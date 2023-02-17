.PHONY: all
all: out/home.nix

out/home.nix: out home.nix embed.bash ../bash/.bash_profile.example ../bash/.bashrc.example ../bash/.bash_logout.example ../gpg/public-key.txt ../tmux/.tmux.conf
	./embed.bash ../bash/.bash_profile.example ../bash/.bashrc.example ../bash/.bash_logout.example ../gpg/public-key.txt ../tmux/.tmux.conf < home.nix > out/home.nix

out:
	-mkdir out
