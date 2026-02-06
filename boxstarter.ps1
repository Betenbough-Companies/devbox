## This command disables User Account Control to run the script without user interaction, it is enabled at the end of the script.
## To avoid security concerns you can comment it if you prefer, otherwise please check the software you install is safe and use this command at your own risk.
Disable-UAC
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine -Force
$Boxstarter.AutoLogin=$false

#--- Install git ---
choco install -y git --params "/GitOnlyOnPath /NoGuiHereIntegration /WindowsTerminal"
#--- Install GnuPG for signing commits (https://www.gnupg.org/) ---
choco install -y gnupg
#--- Install lazygit for git TUI ---
choco install -y lazygit
RefreshEnv

#--- Capture some user input for configuring the dotfiles repository ---
$githubUsername = Read-Host "Enter your GitHub username"
$repoName = Read-Host "Enter the dotfiles repository name (default: dotfiles)" 
if ([string]::IsNullOrWhiteSpace($repoName)) { $repoName = "dotfiles" }
$dotfilesRepo = "https://github.com/$githubUsername/$repoName.git"

#--- Clone required repositories ---
git clone https://github.com/Betenbough-Companies/devbox "$env:USERPROFILE\devbox"
git clone $dotfilesRepo "$env:USERPROFILE\dotfiles"

. "$env:USERPROFILE\devbox\scripts\Helpers.ps1"
. "$env:USERPROFILE\devbox\scripts\InstallWinget.ps1"

#--- Install Windows Terminal Preview version ---
Install-WingetPackage "Microsoft.WindowsTerminal.Preview"

#--- Git configuration ---
Remove-Item -Path "$env:USERPROFILE\.gitconfig" -Force
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.gitconfig" -Target "$env:USERPROFILE\dotfiles\git\.gitconfig"

#--- Output message to configure signing key with GnuPG ---
Write-Host -ForegroundColor Yellow "Please configure your GPG signing key for Git by running the following command:"
Write-Host "git config --global user.signingkey <your-signing-key-id>"

#--- Winget configuration ---
Remove-Item -Path "$env:USERPROFILE\AppData\Local\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json" -Force
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\AppData\Local\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json" -Target "$env:USERPROFILE\dotfiles\winget\settings.json"

#--- Setting up Windows ---
. "$env:USERPROFILE\devbox\scripts\ConfigureEnvironmentVariables.ps1"
. "$env:USERPROFILE\devbox\scripts\SystemConfiguration.ps1"
. "$env:USERPROFILE\devbox\scripts\FileExplorerSettings.ps1"
. "$env:USERPROFILE\devbox\scripts\RemoveDefaultApps.ps1"
. "$env:USERPROFILE\devbox\scripts\Browsers.ps1"
. "$env:USERPROFILE\devbox\scripts\CommonDevTools.ps1"
. "$env:USERPROFILE\devbox\scripts\VirtualEnv.ps1"

#--- reenabling critial items ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
