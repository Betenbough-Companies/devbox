# Dev Box Setup

This repository contains a Boxstarter / Chocolatey based script to configure a Windows developer machine with common tools, settings, and integrations with your personal dotfiles.

## Overview

The entry point is `boxstarter.ps1`. It:

- Imports shared helper functions from `scripts/Helpers.ps1`.
- Disables UAC and sets a permissive execution policy for unattended installation (re-enabled at the end).
- Installs Git, GnuPG, and Lazygit via Chocolatey.
- Clones two repositories into your user profile:
  - `devbox` from `https://github.com/Betenbough-Companies/devbox`.
  - `dotfiles` from `https://github.com/<github-username>/dotfiles.git` (defaults to `amullins`).
- Replaces your global Git config with a symlink to `dotfiles/git/.gitconfig`.
- Replaces Winget settings with a symlink to `dotfiles/winget/settings.json`.
- Runs the configuration scripts from the `devbox/scripts` directory (system settings, apps, WSL, Docker, etc.).
- Re-enables UAC, enables Microsoft Update, and installs Windows Updates when finished.
