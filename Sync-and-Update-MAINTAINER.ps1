#================================================================================
#  Sync-and-Update-MAINTAINER.ps1
#
#  FOR THE REPOSITORY MAINTAINER ONLY.
#  This script performs a full sync and update cycle:
#  1. Stashes all local changes (your fixes, README, etc.).
#  2. Fetches updates from the ORIGINAL Steven Black repo (upstream).
#  3. Merges those updates while preserving your fork's unique commits (rebase).
#  4. Re-applies your stashed changes, handling potential conflicts.
#  5. Updates the Windows hosts file locally.
#  6. Pushes the newly merged content back to YOUR GitHub fork (origin).
#================================================================================

# Step 0: Admin & Prerequisite Checks
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Write-Warning "Restarting with Administrator privileges..."
    Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -File `"$PSCommandPath`""
    exit
}
if (-not (Get-Command git -ErrorAction SilentlyContinue) -or -not (Get-Command pixi -ErrorAction SilentlyContinue)) {
    Write-Error "Git and/or Pixi are not installed or not in your PATH. Please install them."
    Read-Host "Press Enter to exit"
    exit 1
}

# --- Script Body ---
Set-Location -Path $PSScriptRoot
Write-Host "Location set to: $($PSScriptRoot)" -ForegroundColor Green

Write-Host "`nSTEP 1: Saving all your local modifications..." -ForegroundColor Cyan
git stash
if ($LASTEXITCODE -ne 0) { Write-Error "Git stash failed. Aborting."; Read-Host; exit 1 }

Write-Host "`nSTEP 2: Fetching updates from the original Steven Black repo (upstream)..." -ForegroundColor Cyan
git fetch upstream
if ($LASTEXITCODE -ne 0) { Write-Error "Git fetch from upstream failed. Aborting."; Read-Host; exit 1 }

Write-Host "`nSTEP 3: Merging upstream updates while preserving your fork's changes (rebase)..." -ForegroundColor Cyan
# Rebase is cleaner than merge for a fork. It takes upstream's changes and puts your commits on top.
git rebase upstream/master
if ($LASTEXITCODE -ne 0) {
    Write-Error "Automatic rebase failed. A conflict likely occurred. Please resolve it manually in VS Code, then run 'git rebase --continue'. Aborting script."
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "`nSTEP 4: Re-applying your saved modifications..." -ForegroundColor Cyan
git stash pop
if ($LASTEXITCODE -ne 0) {
    Write-Warning "Could not auto-apply stashed changes. Please resolve conflicts manually in VS Code, then run 'git stash drop'."
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "`nSTEP 5: Updating your local Windows hosts file..." -ForegroundColor Cyan
pixi install
pixi run python updateHostsFile.py --auto --replace --backup --extensions fakenews gambling
if ($LASTEXITCODE -ne 0) { Write-Error "The Python script failed. Aborting."; Read-Host; exit 1 }

Write-Host "`nSTEP 6: Pushing all updates to your GitHub fork (origin)..." -ForegroundColor Cyan
# After a rebase, a force push is required. '--force-with-lease' is a safer version.
git push origin master --force-with-lease
if ($LASTEXITCODE -ne 0) { Write-Error "Failed to push to your GitHub fork. Aborting."; Read-Host; exit 1 }

Write-Host "`n==========================================================" -ForegroundColor Green
Write-Host "  MAINTAINER SYNC COMPLETE!" -ForegroundColor Green
Write-Host "  Your fork is updated, and your local hosts file is synced." -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green

Read-Host "Press Enter to exit"