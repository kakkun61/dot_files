# Dot Files

## Home Manager

Use this repository directly as a flake for Home Manager when you don't need a private flake.

When you need a private flake, use a template from this repository to create your own configuration.

```console
$ cd ~/.config/home-manager
$ nix flake init --template github:kakkun61/dot_files
$ # edit flake.nix and home.nix
$ make
```

## PowerShell

```console
> Move-Item $PROFILE "$PROFILE.back"
> $dotFiles = 'path\to\this\repo'
> Copy-Item "$dotFiles\pwsh\profile.example.ps1" $PROFILE
> # edit $PROFILE
```

## diff-highlight

```console
$ cd ./lib/git/contrib/diff-highlight
$ make PERL_PATH=$(which perl)
$ mkdir -p ~/.local/bin
$ install diff-highlight ~/.local/bin
```
