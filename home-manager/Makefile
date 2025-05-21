TARGET = ${HOME}/.config/home-manager/home.nix

.PHONY: all
all: out/home.nix

out/home.nix: home.nix embed.bash ../bash/.bash_profile.example ../bash/.bashrc.example ../bash/.bash_logout.example ../gpg/public-key.txt ../tmux/.tmux.conf
	@mkdir -p $(@D)
	./embed.bash ../bash/.bash_profile.example ../bash/.bashrc.example ../bash/.bash_logout.example ../gpg/public-key.txt ../tmux/.tmux.conf < home.nix > out/home.nix

.PHONY: diff
diff:
	-diff --color ${TARGET} out/home.nix
