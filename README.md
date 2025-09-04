# Dot Files

## Bash

```bash
cd

mv .profile .profile.back
mv .bashrc .bashrc.back
mv .bash_logout .bash_logout.back

dot_files='path/to/this/repo'
cp "$dot_files/bash/.bash_profile.example" .bash_profile
cp "$dot_files/bash/.bashrc.example" .bashrc
cp "$dot_files/bash/.bash_logout.example" .bash_logout

# edit .bash_profile .bashrc .bash_logout
```

## PowerShell

```powershell
Move-Item $PROFILE "$PROFILE.back"

$dotFiles = 'path\to\this\repo'
Copy-Item "$dotFiles\pwsh\profile.example.ps1" $PROFILE

# edit $PROFILE
```

## Home Manager

```bash
dot_files='path/to/this/repo'

cp "$dot_files/home-manager/flake.example.nix" ~/.config/home-manager/flake.nix

# edit flake.nix

home-manager switch --flake ~/.config/home-manager/flake.nix#default
```

## diff-highlight

```bash
cd ./lib/git/contrib/diff-highlight
make PERL_PATH=$(which perl)
mkdir -p ~/.local/bin
install diff-highlight ~/.local/bin
```
