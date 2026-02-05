#--- Include Helpers.ps1 script ---
. "$PSScriptRoot\Helpers.ps1"

#--- Install PowserShell ---
Install-WingetPackage "Microsoft.PowerShell"

#--- Install Editors ---
Install-ChocoPackage "vscode"
Install-ChocoPackage "notepadplusplus"
Install-ChocoPackage "linqpad7"
Install-WingetPackage "Google.Antigravity"

#--- Install mise https://mise.jdx.dev/ ---
Install-WingetPackage "jdx.mise"

#--- Install Python ---
Install-ChocoPackage "python"

#--- Install Rust https://rustup.rs/ ---
Install-WingetPackage "Rustlang.Rustup"

#--- Install 7-zip file archiver https://www.7-zip.org/ ---
Install-ChocoPackage "7zip.install"

#--- Install sysinternals suite https://learn.microsoft.com/en-us/sysinternals/ ---
Install-ChocoPackage "sysinternals"

#--- Install WinMerge diff tool https://winmerge.org/?lang=en ---
Install-ChocoPackage "winmerge"

#--- Install ftp/scp/sftp client https://winscp.net/eng/index.php ---
Install-ChocoPackage "winscp"

#--- Install powertoys utilities https://github.com/microsoft/PowerToys ---
Install-ChocoPackage "powertoys"
Write-Information -ForegroundColor Green "Don't forget to restore your PowerToys settings from your dotfiles!"

#--- Install everything search tool https://www.voidtools.com/ ---
Install-ChocoPackage "Everything"
Install-ChocoPackage "everythingpowertoys"

#--- Install azure command line https://learn.microsoft.com/en-us/cli/azure/ ---
Install-ChocoPackage "azure-cli"
Install-Module -Force Az

#--- Install azure functions core tools https://learn.microsoft.com/en-us/azure/azure-functions/functions-run-local ---
Install-ChocoPackage "azure-functions-core-tools"

#--- Install microsoft dev tunnel https://learn.microsoft.com/en-us/azure/developer/dev-tunnels/get-started?tabs=windows ---
Install-WingetPackage "Microsoft.devtunnel"

#--- Install azure storage explorer https://azure.microsoft.com/en-us/products/storage/storage-explorer ---
Install-ChocoPackage "microsoftazurestorageexplorer"

#--- Install azure service bus explorer https://github.com/paolosalvatori/ServiceBusExplorer ---
Install-ChocoPackage "ServiceBusExplorer"

#--- Install github command line https://cli.github.com/ ---
Install-ChocoPackage "gh"

#--- Install bruno api client https://www.usebruno.com/ ---
Install-ChocoPackage "bruno"

#--- Install JetBrains dotPeek for .NET decompiling https://www.jetbrains.com/decompiler/ ---
Install-ChocoPackage "dotpeek"

#--- Install DuckDB CLI https://duckdb.org/docs/stable/clients/cli/overview ---
Install-ChocoPackage "duckdb"

#--- Install Anthropic Claude AI client https://www.claude.ai/ ---
Install-WingetPackage "Anthropic.Claude"

#--- Install crush coding cli https://github.com/charmbracelet/crush ---
Install-WingetPackage "charmbracelet.crush"

#--- Install Snagit screen capture tool https://www.techsmith.com/snagit/ ---
Install-WingetPackage "TechSmith.Snagit.2024"

#--- Install Fonts ---
Install-WingetPackage "Levitsky.FontBase" # https://fontba.se/
Install-ChocoPackage "FiraCode" # https://github.com/tonsky/FiraCode
Install-ChocoPackage "jetbrainsmono" # https://github.com/JetBrains/JetBrainsMono

#--- Install SDKs ---
Install-WingetPackage "Microsoft.DotNet.SDK.8"
Install-WingetPackage "Microsoft.DotNet.SDK.7"
Install-WingetPackage "Microsoft.DotNet.SDK.6"
Install-WingetPackage "Microsoft.OpenJDK.11"

#--- Install visual studio 2026 professional with custom config from dotfiles repo ---
Install-ChocoPackage "visualstudio2026professional" "--configFilePath `"$env:USERPROFILE\dotfiles\vs2026\2026.vsconfig`""
RefreshEnv
devenv.exe /command "Tools.ImportandExportSettings" "/import:\"$env:USERPROFILE\\dotfiles\\vs2026\\2026.vssettings\""

#--- Install sql server ---
Install-ChocoPackage "sql-server-2025"
# Install Microsoft SQL Server Management Studio using winget
Install-WingetPackage "Microsoft.SQLServerManagementStudio"
winget install Microsoft.SQLServerSetup --silent --force -- -ACTION=install -FEATURES=FullText -IACCEPTSQLSERVERLICENSETERMS -INSTANCENAME="MSSQLSERVER"
Install-WingetPackage "Microsoft.SqlCmd"
Install-WingetPackage "Microsoft.SQLServer.OLEDBDriver"
Install-WingetPackage "Microsoft.CLRTypesSQLServer.2019"

Install-DotnetTool "aspirate"
Install-DotnetTool "dependense"
Install-DotnetTool "dotnet-depends"
Install-DotnetTool "dotnet-ef"
Install-DotnetTool "dotnet-tools-outdated"
Install-DotnetTool "microsoft.dotnet-interactive"
Install-DotnetTool "microsoft.dotnet-openapi"
Install-DotnetTool "microsoft.sqlserver.sqltoolsservicelayer.tool"
Install-DotnetTool "nuget.packagesourcemapper"
Install-DotnetTool "swashbuckle.aspnetcore.cli"

#--- Install starship prompt https://starship.rs/ ---
Install-ChocoPackage "starship"
$starshipConfig = "$env:USERPROFILE\.config\starship\starship.toml"
Set-UserEnvironmentVariable "STARSHIP_CONFIG" $starshipConfig

#--- Update user PATH ---
Add-UserPath "$cargoHome\bin"
Add-UserPath "$pnpmHome"
Add-UserPath "$env:USERPROFILE\.dotnet\tools"
