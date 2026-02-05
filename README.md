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

## Prerequisites

- Windows 10/11 with administrative rights.
- PowerShell (run as Administrator).
- Internet access for downloading packages and cloning repositories.

## Usage

1. Open PowerShell **as Administrator**.
2. Navigate to the repository directory:

   ```powershell
   cd e:\source\dev-box
   ```

3. (Optional) Edit `boxstarter.ps1` to change `githubUsername` if you use a different dotfiles repo:

   ```powershell
   $githubUsername = "your-github-username"
   ```

4. Run the Boxstarter script:

   ```powershell
   .\boxstarter.ps1
   ```

5. Follow any prompts (e.g., GPG signing key configuration) and allow Windows to reboot if required.

## Script Details

### scripts/Helpers.ps1

Defines helper functions used across the other scripts:

- `Install-WingetPackage <Id>` – Installs a package from Winget with silent and agreement flags.
- `Install-ChocoPackage <Id> [Params]` – Installs a Chocolatey package with optional parameters.
- `Install-DotnetTool <Name> [Version]` – Installs a global .NET tool, if the .NET SDK is available.
- `Add-UserPath <Path>` – Adds a directory to the user `PATH` environment variable.
- `Set-UserEnvironmentVariable <Name> <Value>` – Sets a user-scoped environment variable.
- `Get-UserEnvironmentVariable <Name>` – Gets a user-scoped environment variable.

### scripts/CommonDevTools.ps1

Installs common developer tools, SDKs, and configures environment variables and paths.

Key items include:

- Shell and editors:
  - PowerShell (from Winget)
  - Visual Studio Code
  - Notepad++
  - LINQPad 7
- Misc tools:
  - `jdx.mise` (environment manager)
  - Python (Chocolatey)
  - Rust (via rustup / Winget)
  - 7-Zip
  - Sysinternals Suite
  - WinMerge
  - WinSCP
  - PowerToys (with a reminder to restore settings from dotfiles)
  - Everything search + Everything PowerToys integration
- Azure and cloud tooling:
  - Azure CLI (+ `Az` PowerShell module)
  - Azure Functions Core Tools
  - Microsoft Dev Tunnel
  - Azure Storage Explorer
  - Azure Service Bus Explorer
- Developer utilities:
  - GitHub CLI (`gh`)
  - Bruno API client
  - JetBrains dotPeek
  - DuckDB CLI
  - Anthropic Claude client
  - Charmbracelet `crush` CLI
  - Snagit
- Fonts:
  - FontBase
  - Fira Code
  - JetBrains Mono
- SDKs:
  - .NET SDK 8, 7, and 6
  - Microsoft OpenJDK 11
- Visual Studio:
  - Visual Studio 2026 Professional via Chocolatey, using a custom `.vsconfig` from your dotfiles (`vs2026/2026.vsconfig`).
  - Imports Visual Studio settings from `vs2026/2026.vssettings`.
- SQL Server stack:
  - SQL Server 2025 (Chocolatey)
  - SQL Server Management Studio (Winget)
  - Additional SQL Server components via Winget (setup features, SqlCmd, OLE DB driver, CLR types).
- Global .NET tools:
  - `aspirate`, `dependense`, `dotnet-depends`, `dotnet-ef`, `dotnet-tools-outdated`, `microsoft.dotnet-interactive`, `microsoft.dotnet-openapi`, `microsoft.sqlserver.sqltoolsservicelayer.tool`, `nuget.packagesourcemapper`, `swashbuckle.aspnetcore.cli`.
- Environment variables (user scope):
  - `BETENBOUGH_LOCAL_FEED`, `BETENBOUGH_REPOS_ROOT`, `BETENBOUGH_SQL_BACKUP_DIR`.
  - `CARGO_HOME`, `NPM_CONFIG_CACHE`, `NUGET_PACKAGES`, `PIP_CACHE_DIR`, `PNPM_HOME`.
- Starship prompt:
  - Installs `starship` via Chocolatey.
  - Sets `STARSHIP_CONFIG` to `%USERPROFILE%\.config\starship\starship.toml`.
- PATH updates:
  - Adds `CARGO_HOME\bin`, `PNPM_HOME`, and `%USERPROFILE%\.dotnet\tools` to the user PATH.

### scripts/Browsers.ps1

Installs common web browsers via Chocolatey:

- Google Chrome
- Mozilla Firefox
- Microsoft Edge (Dev channel)

### scripts/FileExplorerSettings.ps1

Tweaks Windows File Explorer behavior and visibility:

- Enables display of hidden files, protected OS files, and file extensions.
- Expands the navigation pane to the current folder.
- Shows all folders (e.g., Recycle Bin) in the left pane.
- Sets the "Open File Explorer to" option to **This PC** instead of Quick Access.
- Expands the legacy context menu automatically (equivalent to always using "Show more options").

### scripts/RemoveDefaultApps.ps1

Removes a curated list of preinstalled / consumer-focused apps from Windows for all users and from provisioned apps.

- Defines a `removeApp <AppName>` helper that:
  - Removes matching AppX packages for all users.
  - Removes matching provisioned AppX packages from the image.
- Iterates over a list of built-in apps and OEM/bloat apps (Bing apps, Xbox apps, trial games, some OEM bundles, social media apps, etc.) and attempts to remove each.

### scripts/SystemConfiguration.ps1

Enables Windows developer mode:

- Sets `HKLM:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock`\`AllowDevelopmentWithoutDevLicense` to `1`.

### scripts/WSL.ps1

Installs Windows Subsystem for Linux and a default Ubuntu distro:

- `Microsoft-Windows-Subsystem-Linux` feature (via Chocolatey `windowsfeatures` source).
- `wsl-ubuntu-2204` (Ubuntu 22.04 for WSL).

### scripts/Docker.ps1

Configures prerequisites and tools for Docker development:

- Enables the `containers` Windows optional feature.
- Installs Docker Desktop for Windows via Chocolatey (`docker-for-windows`).
- Installs the VS Code Docker extension (`vscode-docker`).

## Customization

- **Dotfiles repo**: Change the `githubUsername` in `boxstarter.ps1` if your dotfiles live under a different GitHub account or path.
- **Tool selection**: You can comment out or add packages in the scripts under `scripts/` as needed.
- **Environment paths**: Update the default drive and folder locations (e.g., `E:\cache`, `E:\source`) in `CommonDevTools.ps1` to match your machine layout.

## Safety Notes

- The script temporarily disables UAC and removes the existing `%USERPROFILE%\.gitconfig` and Winget settings, replacing them with symlinks into your dotfiles.
- `RemoveDefaultApps.ps1` irreversibly removes many built-in apps for all users; review the app list before running in a shared or personal environment.
- Always review and trust the contents of your `dotfiles` repo before running the full setup on a new machine.