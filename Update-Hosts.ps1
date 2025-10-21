#================================================================================
#  UPDATE-HOSTS.PS1 (Fork Version) - Automated Steven Black Hosts Update Script
#
#  This script is designed for the 'hosts-for-windows' fork. It automates
#  the entire process of updating the hosts file safely and efficiently.
#
#  To Use: Right-click this file and select "Run with PowerShell".
#
#  WHAT IT DOES:
#  1. Checks for Administrator privileges and restarts itself if needed.
#  2. Checks if Git and Pixi are installed.
#  3. Pulls the latest host file data from YOUR GitHub fork.
#  4. Installs the correct Python environment using Pixi.
#  5. Runs the (already fixed) Python script to build and install the hosts file.
#================================================================================

# Step 0: Ensure the script is running as an Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Write-Warning "This script needs Administrator privileges. Attempting to restart as Admin..."
    Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -File `"$PSCommandPath`""
    exit
}

# --- Configuration ---
# Get the directory where this script is located
$projectPath = $PSScriptRoot

# --- Script Body ---
try {
    Set-Location -Path $projectPath
    Write-Host "Successfully changed directory to `"$projectPath`"" -ForegroundColor Green
}
catch {
    Write-Error "Could not find the project path: `"$projectPath`"."
    Read-Host "Press Enter to exit"
    exit 1
}

# --- Prerequisite Checks ---
Write-Host "`nSTEP 1: Checking for required tools (Git and Pixi)..." -ForegroundColor Cyan
$gitExists = Get-Command git -ErrorAction SilentlyContinue
$pixiExists = Get-Command pixi -ErrorAction SilentlyContinue

if (-not $gitExists) {
    Write-Error "Git is not installed or not in your PATH. Please install Git from git-scm.com"
    Read-Host "Press Enter to exit"
    exit 1
}
if (-not $pixiExists) {
    Write-Error "Pixi is not installed or not in your PATH. Please install Pixi from pixi.sh"
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host "All required tools are found." -ForegroundColor Green


Write-Host "`nSTEP 2: Downloading latest hosts data from your GitHub fork..." -ForegroundColor Cyan
# This command forcefully updates your local files to match what's in your online fork.
# It's the safest way to update and avoids any merge conflicts.
git fetch origin
git reset --hard origin/master
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to pull updates from GitHub. Aborting."
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host "Project is up-to-date." -ForegroundColor Green


Write-Host "`nSTEP 3: Setting up Python environment with Pixi..." -ForegroundColor Cyan
# This ensures the correct versions of Python and other tools are installed.
pixi install
if ($LASTEXITCODE -ne 0) {
    Write-Error "Pixi failed to install the environment. Aborting."
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host "Pixi environment is ready." -ForegroundColor Green


Write-Host "`nSTEP 4: Building and installing the new hosts file..." -ForegroundColor Cyan
# This is the "update the database" step. It runs the Python script, which
# reads all the host data files and generates the final output.
pixi run python updateHostsFile.py --auto --replace --backup --extensions fakenews gambling
if ($LASTEXITCODE -ne 0) {
    Write-Error "The Python script failed to execute. Please review the output above for any errors."
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "`n========================================================" -ForegroundColor Green
Write-Host "  Update process completed successfully!" -ForegroundColor Green
Write-Host "  Your hosts file is now up-to-date." -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green

Read-Host "Press Enter to exit"