<#
.SYNOPSIS
Installs a package using winget.

.PARAMETER Id
The winget package identifier to install.
#>
function Install-WingetPackage {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [Alias("Package")]
        [ValidateNotNullOrEmpty()]
        [string]$Id
    )
    
    try {
        Write-Verbose "Installing $Id..." -Verbose
        winget install --id $Id --silent --accept-source-agreements --accept-package-agreements
    }
    catch {
        Write-Error "Failed to install ${Id}: $_"
    }
}

<#
.SYNOPSIS
Installs a Chocolatey package.

.PARAMETER Id
The Chocolatey package identifier to install.

.PARAMETER Params
Optional parameter string to pass to the Chocolatey install command.
#>
function Install-ChocoPackage {
		[CmdletBinding()]
		param (
				[Parameter(Position = 0, Mandatory = $true)]
				[Alias("Package")]
				[ValidateNotNullOrEmpty()]
				[string]$Id,
				
				[Parameter(Position = 1)]
				[Alias("P")]
				[string]$Params = ""
		)
		
		try {
				Write-Verbose "Installing $Id..." -Verbose
				if ($Params -ne "") {
						choco install -y $Id --params "$Params"
				} else {
						choco install -y $Id
				}
		}
		catch {
				Write-Error "Failed to install ${Id}: $_"
		}
}

<#
.SYNOPSIS
Installs a global .NET tool using the dotnet CLI.

.PARAMETER Name
The name of the .NET tool to install.

.PARAMETER Version
Optional version of the .NET tool. If omitted, installs the latest version.
#>
function Install-DotnetTool {
		[CmdletBinding()]
		param (
				[Parameter(Position = 0, Mandatory = $true)]
				[ValidateNotNullOrEmpty()]
				[string]$Name,
				
				[Parameter(Position = 1)]
				[string]$Version = ""
		)

		if (-not (Test-CommandExists dotnet)) {
				Write-Error ".NET SDK not found. Cannot install .NET tool ${Name}."
				return
		}
		
		try {
				Write-Verbose "Installing .NET tool $Name..." -Verbose
				if ($Version -ne "") {
						dotnet tool install --global $Name --version $Version
				} else {
						dotnet tool install --global $Name
				}
		}
		catch {
				Write-Error "Failed to install .NET tool ${Name}: $_"
		}
}

<#
.SYNOPSIS
Adds a directory to the current user's PATH environment variable.

.PARAMETER Path
The directory path to add to the user PATH variable.

.OUTPUTS
System.Boolean
Returns $true if the PATH variable was modified; otherwise $false.
#>
function Add-UserPath {
		[CmdletBinding()]
		param (
				[Parameter(Position = 0, Mandatory = $true)]
				[ValidateNotNullOrEmpty()]
				[string]$Path
		)
		
		$pathModified = $false
		$variableName = 'Path'
		$userPath = Get-UserEnvironmentVariable -Name $variableName
		
		if (-not ($userPath.Split(';') -contains $Path)) {
				$userPath += ";$Path"
				Set-UserEnvironmentVariable -Name $variableName -Value $userPath
				$pathModified = $true
				Write-Verbose "Added $Path to the User PATH environment variable." -Verbose
		} else {
				Write-Verbose "Path $Path already exists in User PATH." -Verbose
		}
		
		return $pathModified
}

<#
.SYNOPSIS
Sets a user-scoped environment variable.

.PARAMETER Name
The environment variable name.

.PARAMETER Value
The value to assign to the environment variable.
#>
function Set-UserEnvironmentVariable {
		[CmdletBinding()]
		param (
				[Parameter(Position = 0, Mandatory = $true)]
				[ValidateNotNullOrEmpty()]
				[string]$Name,
				
				[Parameter(Position = 1, Mandatory = $true)]
				[AllowEmptyString()]
				[string]$Value
		)
		
		try {
				[System.Environment]::SetEnvironmentVariable($Name, $Value, [System.EnvironmentVariableTarget]::User)
				Write-Verbose "Set environment variable '$Name' to '$Value'" -Verbose
		}
		catch {
				Write-Error "Failed to set environment variable '${Name}': $_"
		}
}

<#
.SYNOPSIS
Gets the value of a user-scoped environment variable.

.PARAMETER Name
The environment variable name.

.OUTPUTS
System.String
Returns the value of the environment variable, or $null if not found or on error.
#>
function Get-UserEnvironmentVariable {
		[CmdletBinding()]
		param (
				[Parameter(Position = 0, Mandatory = $true)]
				[ValidateNotNullOrEmpty()]
				[string]$Name
		)
		
		try {
				$value = [System.Environment]::GetEnvironmentVariable($Name, [System.EnvironmentVariableTarget]::User)
				return $value
		}
		catch {
				Write-Error "Failed to get environment variable '${Name}': $_"
				return $null
		}
}

<#
.SYNOPSIS
Removes a built-in Windows app for all users and from provisioned apps.

.PARAMETER appName
The package name or wildcard pattern of the app(s) to remove.
#>
function Remove-App {
	Param ([string]$appName)
	Write-Output "Trying to remove $appName"
	Get-AppxPackage $appName -AllUsers | Remove-AppxPackage
	Get-AppXProvisionedPackage -Online | Where DisplayName -like $appName | Remove-AppxProvisionedPackage -Online
}
