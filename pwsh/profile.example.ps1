# dotfiles リポジトリーのディレクトリーを指定する
$dotFiles = '.'

. $dotFiles\pwsh\lib.ps1

Import-Module Posh-Git
Import-Module posh-sshell
Import-Module PSBookmark
Import-Module psake
Import-Module ghcman
Import-Module path-switcher
Import-Module code-page

Import-DotenvModule

# posh-sshell
Start-SshAgent -Quiet

Initialize-Chocolatey

Initialize-DotenvModule

Initialize-Python

# the fuck
Invoke-Expression "$(thefuck --alias)"

# prompt
Set-Item -Path Function:\prompt -Value (Get-Prompt) -Options ReadOnly
