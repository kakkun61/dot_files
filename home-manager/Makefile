.PHONY: all
all: out/home.nix

out/home.nix: out home.nix embed.bash ../bash/.bash_profile.example ../bash/.bashrc.example ../bash/.bash_logout.example ../gpg/public-key.txt
	./embed.bash ../bash/.bash_profile.example ../bash/.bashrc.example ../bash/.bash_logout.example ../gpg/public-key.txt < home.nix > out/home.nix

out:
	-mkdir out
