Set-StrictMode -Version Latest

$dotFilesPwshDir = $PSScriptRoot
if ((Get-Item $PSCommandPath).Target) {
    $dotFilesPwshDir = Split-Path -Parent ((Get-Item $PSCommandPath).Target)
}

function Initialize-Chocolatey {
    $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
    Import-Module $ChocolateyProfile
}

function Import-DotenvModule {
    Import-Module $dotFilesPwshDir\..\lib\poshdotenv\module\dotenv\dotenv.psd1
}

function Get-Prompt {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Scope = 'Function', Target = 'Get-Prompt', Justification = 'Prompt is always host')]

    param ()

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
    $prompt
}

function Initialize-Python {
    $Env:PYTHONIOENCODING = "utf-8"
}

function Add-WslOpenToPath {
    param ()
    $Env:PATH = "$dotFilesPwshDir\..\lib\wsl-open;$Env:PATH"
}

function Show-Notification {
    param (
        [string] $Title,
        [string] $Message
    )
    powershell.exe -ExecutionPolicy Unrestricted -Command "& { . $dotFilesPwshDir\..\lib\toast-in-powershell\toast.ps1; Show-Notification $Title $Message }"
}
