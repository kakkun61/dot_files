$actualScriptRoot = $PSScriptRoot
if ((Get-Item $PSCommandPath).Target) {
    $actualScriptRoot = Split-Path -Parent ((Get-Item $PSCommandPath).Target)
}

function Initialize-Chocolatey {
    $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
    Import-Module $ChocolateyProfile
}

function Import-DotenvModule {
    Import-Module $actualScriptRoot\..\lib\poshdotenv\module\dotenv\dotenv.psd1
}

function Get-Prompt {
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

function Initialize-Fuck {
    Invoke-Expression "$(thefuck --alias)"
}
