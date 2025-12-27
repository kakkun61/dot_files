# Dot Files

## Home Manager

```bash
cd ~/.config/home-manager
nix flake init --template github:kakkun61/dot_files

# edit flake.nix and home.nix

make
```

## PowerShell

```powershell
Move-Item $PROFILE "$PROFILE.back"

$dotFiles = 'path\to\this\repo'
Copy-Item "$dotFiles\pwsh\profile.example.ps1" $PROFILE

# edit $PROFILE
```

## diff-highlight

```bash
cd ./lib/git/contrib/diff-highlight
make PERL_PATH=$(which perl)
mkdir -p ~/.local/bin
install diff-highlight ~/.local/bin
```
