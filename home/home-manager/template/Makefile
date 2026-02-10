.PHONY: all
all:
	$(MAKE) update
	$(MAKE) switch

.PHONY: switch
switch:
	home-manager switch --flake .

.PHONY: build
build:
	home-manager build --flake .

.PHONY: update
update:
	nix flake update

.PHONY: diff
diff:
	tmp=$${TMPDIR:-/tmp}/home-manager-diff \
		&& rm -rf $$tmp \
		&& mkdir -p $$tmp \
		&& pushd $$tmp \
		&& nix flake init --template github:kakkun61/dot_files 2> /dev/null \
		&& popd \
		&& diff --exclude .git --exclude result --color=always . $$tmp
