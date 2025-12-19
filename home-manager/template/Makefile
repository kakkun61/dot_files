.PHONY: all
all:
	$(MAKE) update
	$(MAKE) switch

.PHONY: switch
switch:
	home-manager switch --flake .

.PHONY: update
update:
	nix flake update
