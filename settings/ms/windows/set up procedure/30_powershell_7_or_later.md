# PowerShell 7 or later

https://learn.microsoft.com/en-us/powershell/?view=powershell-7.3

https://github.com/PowerShell/PowerShell
PowerShell-7.3.5-win-x64.msi

install to default location "C:\Program Files\PowerShell"
* it will create a sub-folder "7"

### Win-X -> Terminal

Ctrl+, to open Settings
	Profiles, 'PowerShell' (not 'Windows Powershell' or another)
		[double check] this is "C:\Program Files\PowerShell\7\pwsh.exe"
		[consider renaming] to 'PowerShell 7'. (The rest of this doc will assume this.)
	Startup
		Default profile
			-> [consider setting] to 'PowerShell 7'

### Win-X -> Terminal -> PowerShell 7
```PowerShell
Update-Help -UICulture en-US
```

### Win-X -> Terminal (Admin) -> PowerShell 7
```PowerShell
Get-ExecutionPolicy

# Consider:
#Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
```

## Consider: Set up the PSGallery repository

### Win-X -> Terminal -> PowerShell 7
```PowerShell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted

Get-PSRepository -Name PSGallery
Set-PSRepository -Name PSGallery -SourceLocation https://www.powershellgallery.com/api/v2 -InstallationPolicy Trusted
```
