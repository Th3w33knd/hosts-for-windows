# Steven Black Hosts for Windows (Automated)

This is a user-friendly, Windows-focused fork of the acclaimed [Steven Black hosts](https://github.com/StevenBlack/hosts) project. Its purpose is to provide a simple, automated way to block ads, malware, and other unwanted content on your computer using a specialized `hosts` file.

This fork is pre-configured with a script that handles everything for you.

### Features

* **Simple & Automated:** A single script updates everything. No manual Git commands needed.
* **Lightweight:** The download is only a few megabytes, not the 1.7 GB of the original repository.
* **Fully Customizable:** Easily add your own websites to block (`blacklist`) or unblock (`whitelist`).
* **Clean Environment:** Uses [Pixi](https://pixi.sh/) to manage the Python environment, keeping your system clean.
* **Pre-configured:** Comes ready to block adware, malware, fake news, and gambling sites by default.

---

## Getting Started

Follow these simple steps to get set up.

### Prerequisites (One-Time Install)

1. **Install Git:** Go to [git-scm.com/download/win](https://git-scm.com/download/win) and run the installer. The default options are fine.
2. **Install Pixi:** Go to [pixi.sh](https://pixi.sh/latest/) and follow the installation instructions for Windows.

### Installation (One-Time Setup)

1. Open **Command Prompt**, **PowerShell**, or any terminal.
2. Run this command to download a lightweight copy of the project:

    ```cmd
    git clone --depth 1 https://github.com/Th3w33knd/hosts-for-windows.git
    ```

3. Navigate into the new folder:

    ```cmd
    cd hosts-for-windows
    ```

You are now ready to go!

---

## How to Update Your Hosts File

To block unwanted sites or update your blocklists at any time, just follow this one step:

1. Navigate into the `hosts-for-windows` folder.
2. Find the `Update-Hosts-USER.ps1` script.
3. **Right-click** it and select **"Run with PowerShell"**.

The script will automatically handle everything: it will ask for Administrator permission, download the latest blocklists, and update your Windows hosts file.

### How to Customize Your Blocklists

The first time you run the `Update-Hosts-USER.ps1` script, it will automatically create two files for you: `blacklist` and `whitelist`.

* **To block additional sites:** Open the `blacklist` file with any text editor and add domains in this format, one per line:

    ```
    0.0.0.0 some-annoying-site.com
    ```

* **To unblock a site:** Open the `whitelist` file and add just the domain name, one per line:

    ```
    a-site-i-need.com
    ```

Your changes in these files are personal and will be automatically applied every time you run the update script.

---

# Maintainer's Guide for `hosts-for-windows` Fork

This document is for the maintainer of this repository. It outlines the project structure and the workflow for keeping this fork synchronized with the original [Steven Black hosts](https://github.com/StevenBlack/hosts) repository.

### Repository Structure

* **`updateHostsFile.py`:** The core Python script, modified with a fix to work correctly on Windows when run with administrator privileges.
* **`Sync-and-Update-MAINTAINER.ps1`:** Your primary tool. This script automates the entire maintenance workflow.
* **`Update-Hosts-USER.ps1`:** The simple script for end-users. It only pulls from this fork and never pushes.
* **`pixi.toml`:** Defines the Python environment and dependencies, ensuring reproducibility.
* **`.gitignore`:** Configured to ignore user-specific files like `blacklist` and `whitelist`.
* **`blacklist.example` / `whitelist.example`:** Template files used by the user script to create personal blocklists for new users.

### One-Time Setup on a New Machine

If you set up this project on a new computer, you need to tell your local Git repository where the original "upstream" project is.

```cmd
# Navigate to the project folder
cd hosts-for-windows

# Add a remote named 'upstream' pointing to the original repo
git remote add upstream https://github.com/StevenBlack/hosts.git
```

---

## The Maintenance Workflow

Your primary job is to periodically pull updates from the original Steven Black repository (`upstream`) and push them to your fork (`origin`). The `Sync-and-Update-MAINTAINER.ps1` script automates this entire process.

### How to Sync the Fork

1. Navigate into the `hosts-for-windows` folder.
2. Find the `Sync-and-Update-MAINTAINER.ps1` script.
3. **Right-click** it and select **"Run with PowerShell"**.

### What the Maintainer Script Does

This script is designed to be robust and handle the complexities of managing a fork:

1. **`git stash`:** It first saves all your local modifications (your Python fix, the scripts, the README) to a temporary "stash". This cleans the working directory for a smooth merge.
2. **`git fetch upstream`:** It downloads the latest changes from the *original* Steven Black repository.
3. **`git rebase upstream/master`:** This is the crucial step. Instead of a messy merge, it takes the upstream changes and replays your unique commits (like the Python fix and adding the scripts) on top of them. This keeps the project history clean and linear.
4. **`git stash pop`:** It re-applies your stashed changes.
5. **`pixi run ...`:** It runs the Python script to update your own local Windows hosts file, acting as a final test.
6. **`git push --force-with-lease`:** After a rebase, a force push is necessary to update the remote branch. `--force-with-lease` is a safer version that won't overwrite work if someone else (unlikely) has pushed to your fork.

### Handling Conflicts (Rare)

It is possible, though rare, that the original project might update the `updateHostsFile.py` script in a way that conflicts with your fix.

If this happens, the `git rebase` or `git stash pop` step in the script will fail and pause.

**To resolve:**

1. Open the `hosts-for-windows` folder in a code editor like VS Code.
2. The conflicted file(s) will be marked. Open them and you will see Git's conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`).
3. Manually edit the file to merge the changes and keep your fix intact.
4. Save the file.
5. In the terminal, run `git add .` to stage the resolved file.
6. Continue the process by running `git rebase --continue`.
7. Once the rebase is complete, you can re-run the maintainer script, and it should proceed to the push step.
