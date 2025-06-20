# PowerShell 7 or later

### Docs
https://learn.microsoft.com/en-us/powershell/?view=powershell-7.4

### Download

https://github.com/PowerShell/PowerShell <br/>
Currently `PowerShell-7.4.3-win-x64.msi`

Install to default location `"C:\Program Files\PowerShell"`.<br/>
(It will create a sub-folder `"7"`.)

* [uncheck] Add PowerShell to Path Environment varialbe<br/>
* [check] Register Windows Event Logging Manifest<br/>
* [uncheck] Enable PowerShell remoting<br/>

Consider:<br/>
* [check] Disable telemetry<br/>
* [check] Add 'Open here' context menu to Explorer<br/>
* [check] Add 'Run with PowerShell 7' context menu for PowerShell files<br/>

### Next

Consider:<br/>
* [check] Enable updating PowerShell through Microsoft Update or WSUS<br/>
* [check] Use Microsoft Update when I check for updates<br/>

#### Win-X -> Terminal

```
Ctrl+, to open Settings
	Profiles, 'PowerShell' (not 'Windows Powershell' or another)
		[double check] this is "C:\Program Files\PowerShell\7\pwsh.exe"
		[consider renaming] to 'PowerShell 7'. (The rest of this doc will assume this.)
	Startup
		Default profile
			-> [consider setting] to 'PowerShell 7'
```

#### Win-X -> Terminal -> PowerShell 7
```PowerShell
Update-Help -UICulture en-US

Get-ExecutionPolicy
```

Consider:

#### Win-X -> Terminal (Admin) -> PowerShell 7
```PowerShell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
```

### Set up the PSGallery repository

#### Win-X -> Terminal (Admin) -> PowerShell 7
```PowerShell
Get-PSRepository -Name PSGallery
Set-PSRepository -Name PSGallery -SourceLocation https://www.powershellgallery.com/api/v2 -InstallationPolicy Trusted
```
