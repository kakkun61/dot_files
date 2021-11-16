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
