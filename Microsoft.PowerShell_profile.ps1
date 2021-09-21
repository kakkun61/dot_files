$actualScriptRoot = $PSScriptRoot
if ((Get-Item $PSCommandPath).Target) {
    $actualScriptRoot = Split-Path -Parent ((Get-Item $PSCommandPath).Target)
}

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path $ChocolateyProfile) {
    Import-Module $ChocolateyProfile
}

Import-Module Posh-Git
Import-Module posh-sshell
Import-Module PSBookmark
Import-Module ghcups
Import-Module path-switcher
Import-Module $actualScriptRoot\poshdotenv\module\dotenv\dotenv.psd1

# posh-sshell
Start-SshAgent -Quiet

# prompt
[ScriptBlock] $prompt = {
    $realLASTEXITCODE = $LASTEXITCODE
    $now = get-date -format "HH:mm:ss"
    $exitCode = ""
    if (-not ($?)) {
        $exitCode = Write-Host "LASTEXITCODE: $realLASTEXITCODE" -ForegroundColor Red
    }
    $host.UI.RawUI.WindowTitle = Split-Path $pwd.ProviderPath -Leaf
    $path = Write-Host $pwd.ProviderPath -NoNewLine -ForegroundColor Green
    $vcsStatus = Write-VcsStatus
    $ready = '>' * ($nestedPromptLevel + 1)
    $Global:LASTEXITCODE = $realLASTEXITCODE
    "$exitCode$path [$now]$vcsStatus`n$ready "
    return
}

Set-Item -Path Function:\prompt -Value $prompt -Options ReadOnly

# Python
$Env:PYTHONIOENCODING = "utf-8"

# Fuck
try {
    Invoke-Expression "$(thefuck --alias)"
}
catch [System.Management.Automation.CommandNotFoundException] {
    # do nothing
}
