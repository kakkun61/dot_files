.PHONY: all
all: out/home.nix

out/home.nix: out home.nix embed.bash ../bash/.bash_profile.example ../bash/.bashrc.example ../bash/.bash_logout.example
	./embed.bash ../bash/.bash_profile.example ../bash/.bashrc.example ../bash/.bash_logout.example < home.nix > out/home.nix

out:
	-mkdir out
