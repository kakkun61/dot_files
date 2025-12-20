param@{
  root,
  envar,
  git,
}:
modParam@{ pkgs, lib, ... }:
lib.foldr lib.recursiveUpdate (import ./home/base.nix param modParam) [ ]
