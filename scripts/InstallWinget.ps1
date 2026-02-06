# Ensure winget is installed and up to date
$hasPackageManager = Get-AppPackage -name 'Microsoft.DesktopAppInstaller'
if (!$hasPackageManager -or [version]$hasPackageManager.Version -lt [version]"1.10.0.0") {
    Write-Host "Windows Package Manager not found or outdated. Please install the latest version from the Microsoft Store."
    # A script might pause here if manual intervention is preferred, or attempt a silent install
    # from the GitHub release page if the environment allows.
    # For automation, a typical approach might be to use the following line and handle the prompt in some way
    Start-Process ms-appinstaller:?source=https://aka.ms/getwinget
    Read-Host -Prompt "Press enter to continue after winget installation/update completes"
}
