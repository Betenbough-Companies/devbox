#include Helpers.ps1 script
. "$PSScriptRoot\Helpers.ps1"

# Configure environment variable for local repos
$reposRoot = Read-Host -Prompt "Where would you like to store your local dev repos? (default: ~\repos)"
if ([string]::IsNullOrWhiteSpace($reposRoot)) {
		$reposRoot = "$env:USERPROFILE\repos"
}
# check if the directory exists, if not create it
if (-not (Test-Path -Path $reposRoot)) {
		New-Item -ItemType Directory -Path $reposRoot | Out-Null
}
Set-UserEnvironmentVariable "BETENBOUGH_REPOS_ROOT" $reposRoot

# Confgure environment variable for local nuget package feed
$localFeed = Read-Host -Prompt "Where would you like to store your local nuget package feed? (default: ~\betenbough-local-feed)"
if ([string]::IsNullOrWhiteSpace($localFeed)) {
		$localFeed = "$env:USERPROFILE\betenbough-local-feed"
}
# check if the directory exists, if not create it
if (-not (Test-Path -Path $localFeed)) {
		New-Item -ItemType Directory -Path $localFeed | Out-Null
}
Set-UserEnvironmentVariable "BETENBOUGH_LOCAL_FEED" $localFeed

# Configure environment variable for SQL backup directory
$sqlBackupDir = Read-Host -Prompt "Where would you like to store your SQL backups? (default: ~\sql-backups)"
if ([string]::IsNullOrWhiteSpace($sqlBackupDir)) {
		$sqlBackupDir = "$env:USERPROFILE\sql-backups"
}
# check if the directory exists, if not create it
if (-not (Test-Path -Path $sqlBackupDir)) {
		New-Item -ItemType Directory -Path $sqlBackupDir | Out-Null
}
Set-UserEnvironmentVariable "BETENBOUGH_SQL_BACKUP_DIR" $sqlBackupDir

# Configure root path for storing language-specific caches (e.g. cargo, npm, pip, etc.)
$cacheRoot = Read-Host -Prompt "Where would you like to store your language-specific caches? (default: ~\cache)"
if ([string]::IsNullOrWhiteSpace($cacheRoot)) {
		$cacheRoot = "$env:USERPROFILE\cache"
}
# check if the directory exists, if not create it
if (-not (Test-Path -Path $cacheRoot)) {
		New-Item -ItemType Directory -Path $cacheRoot | Out-Null
}

$cargoHome = "$cacheRoot\.cargo"
Set-UserEnvironmentVariable "CARGO_HOME" $cargoHome

$npmCache = "$cacheRoot\npm-cache"
Set-UserEnvironmentVariable "NPM_CONFIG_CACHE" $npmCache

$nugetPackages = "$cacheRoot\.nuget\packages"
Set-UserEnvironmentVariable "NUGET_PACKAGES" $nugetPackages

$pipCache = "$cacheRoot\pip"
Set-UserEnvironmentVariable "PIP_CACHE_DIR" $pipCache

$pnpmHome = "$env:LOCALAPPDATA\pnpm"
Set-UserEnvironmentVariable "PNPM_HOME" $pnpmHome
