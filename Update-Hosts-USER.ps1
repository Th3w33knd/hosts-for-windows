#================================================================================
#  Update-Hosts-USER.ps1
#
#  FOR USERS OF THE 'hosts-for-windows' FORK.
#  This script is the simplest and safest way to keep your hosts file updated.
#
#  To Use: Right-click this file and select "Run with PowerShell".
#
#  WHAT IT DOES:
#  1. Checks for Administrator privileges.
#  2. Pulls the latest version of the project from the public GitHub fork.
#     (This will overwrite any accidental local changes, ensuring a clean state).
#  3. Runs the Python script to update your Windows hosts file.
#================================================================================

# Step 0: Admin & Prerequisite Checks
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Write-Warning "Restarting with Administrator privileges..."
    Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -File `"$PSCommandPath`""
    exit
}
if (-not (Get-Command git -ErrorAction SilentlyContinue) -or -not (Get-Command pixi -ErrorAction SilentlyContinue)) {
    Write-Error "Git and/or Pixi are not installed or not in your PATH. Please install them first."
    Read-Host "Press Enter to exit"
    exit 1
}

# --- Script Body ---
Set-Location -Path $PSScriptRoot
Write-Host "Location set to: $($PSScriptRoot)" -ForegroundColor Green

Write-Host "`nSTEP 1: Downloading the latest version from the hosts-for-windows project..." -ForegroundColor Cyan
# This forcefully resets the local folder to match the online repository.
# It's the safest way for users, as it prevents all conflicts.
git fetch origin
git reset --hard origin/master
if ($LASTEXITCODE -ne 0) { Write-Error "Failed to download updates. Please check your internet connection. Aborting."; Read-Host; exit 1 }

Write-Host "`nSTEP 2: Setting up Python environment..." -ForegroundColor Cyan
pixi install
if ($LASTEXITCODE -ne 0) { Write-Error "Pixi failed to install the environment. Aborting."; Read-Host; exit 1 }

Write-Host "`nSTEP 3: Updating your local Windows hosts file..." -ForegroundColor Cyan
pixi run python updateHostsFile.py --auto --replace --backup --extensions fakenews gambling
if ($LASTEXITCODE -ne 0) { Write-Error "The Python script failed. Aborting."; Read-Host; exit 1 }


Write-Host "`n========================================================" -ForegroundColor Green
Write-Host "  Update process completed successfully!" -ForegroundColor Green
Write-Host "  Your hosts file is now up-to-date." -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green

Read-Host "Press Enter to exit"