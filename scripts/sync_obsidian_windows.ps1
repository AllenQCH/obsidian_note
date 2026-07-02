param(
    [string]$Message
)

$ErrorActionPreference = "Stop"

$repo = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $repo

git fetch origin
git pull --rebase --autostash origin main

$changes = git status --porcelain
if ($changes) {
    if (-not $Message) {
        $Message = "vault backup: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    }

    git add -A
    git commit -m $Message
}

git push origin main
git status --short --branch
