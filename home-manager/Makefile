TARGET = ${HOME}/.config/home-manager/flake.nix

.PHONY: diff
diff:
	-diff --color ./flake.example.nix ${TARGET}

.PHONY: format
format:
	nixpkgs-fmt ./flake.nix ./home.nix ./flake.example.nix
