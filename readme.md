# The Simple "How to Use" Guide (For You and Your Friends)**

This is the reproducible, easy-to-share process you wanted.

**Prerequisites:**
1.  **Install Git:** Go to [git-scm.com](https://git-scm.com/download/win) and install it (default options are fine).
2.  **Install Pixi:** Go to [pixi.sh](https://pixi.sh/latest/) and follow the installation instructions for Windows.

**One-Time Setup:**
1.  Open **Command Prompt** (or any terminal).
2.  Run this command to get a lightweight copy of the project:
    ```cmd
    git clone --depth 1 https://github.com/Th3w33knd/hosts-for-windows.git
    ```
3.  Navigate into the new folder: `cd hosts-for-windows`
4.  **(Optional but Recommended)** Create your personal `blacklist` and `whitelist` files inside this folder. Add any domains you want to block or unblock.

**To Update Your Hosts File (Anytime):**
1.  Find the `Update-Hosts.ps1` script inside the `hosts-for-windows` folder.
2.  **Right-click** it and select **"Run with PowerShell"**.

That's it! The script will handle everything else automatically.