# Basic MS Windows set up procedure

Things I do when setting up a new Windows system for personal use.

## First

If migrating from a different computer, be sure to
* Save all personal files
* Export all bookmarks from browser profiles
* Check OneDrive to make sure everything has finished syncing

<br/>

* [Create Windows 11 Installation Media](https://www.microsoft.com/en-us/software-download/windows11)

# Settings pertaining to entire system

## CapsLock to Ctrl

See [capslock-to-ctrl.cmd](../swap-ctrl-capslock/capslock-to-ctrl.cmd)
and [swap-ctrl-capslock.txt](../swap-ctrl-capslock/swap-ctrl-capslock.txt)

Download https://raw.githubusercontent.com/marshray/marshray-public-misc/main/settings/ms/windows/swap-ctrl-capslock/capslock-to-ctrl.cmd

### Win-X -> Terminal (Admin)

```cmd
"%USERPROFILE\Downloads\capslock-to-ctrl.cmd"
```

Then run it again with the `--actually-make-changes` command line argument.

Reboot when convenient.

## Update

### Win-X -> System

Bottom left item: Windows Update

[click] Check for updates button

Watch and wait

'Restart and update' when requested

Repeat until it says "You're up to date"

## Reduce the aggressiveness of the sleep settings

### Win-X -> Power Options
```
Screen and sleep
	When plugged in, turn off my screen after
		45 minutes
	When plugged in, put my device to sleep after
		1 hour
Power mode
	-> Best performance
```
## (Very Optional) Disable Edge new tab page content loading

Note: This method seems to be causing a weird refresh 2 seconds after opening a new tab.
It's possible that a different IP would fix that.

### Win-X -> Terminal (Admin)

```
(set misc-backups=%USERPROFILE%\misc-backups)
if not exist "%misc-backups%" mkdir "%misc-backups%"

(set hostsfile=%SystemRoot%\system32\drivers\etc\hosts)
copy "%hostsfile%" "%misc-backups%\hosts.0.txt"
echo. >>%hostsfile%
echo # Disable edge new tab page content loading >>%hostsfile%
echo 0.0.0.0  ntp.msn.com >>%hostsfile%
echo 0.0.0.0  ntp.msn.com >>%hostsfile%
(set hostsfile=)
```

## "Advanced System Settings"

```
Win-X -> System -> Advanced System Settings
	Computer Name tab
		Computer description
			[edit] put something in here
			[click] Change... To rename this computer
			Computer Name/Domain Changes
				[edit] Workgroup Change to something else
	Advanced tab
		[click] Settings... in the Performance section
			Data Execution Prevention tab
				[select] Turn on DEP for all programs and services
		[click] Environment Variables
			System Variables ->
				[click] New
					POWERSHELL_TELEMETRY_OPTOUT 1
			User variables ->
				[click] New
					PSModulePath %USERPROFILE%\Documents\PSModulePath
				Path [click] Edit
					Add C:\app\bin
	Remote tab
		[uncheck] Allow Remote Assistance connections to this computer
		[select] Don't allow remote connections to this computer
```

## Terminal app

Win key (start menu)

Type "terminal"

Pin to Start

### Win-X -> Terminal

Pin to taskbar

Ctrl+, (Settings)
```
Startup
	Default terminal application
		-> Windows Terminal
	Launch size
		-> 120 x 50
```

## Create C:\app\bin

### Win-X -> Terminal (Admin) -> PowerShell 7

Can also be done via Explorer UI and Properties Security tab, but this method creates the
directory with the correct permissions in the first place.

```PowerShell
$builtin_administrators = [System.Security.Principal.NTAccount]::new("BUILTIN", "Administrators")

$acl = New-Object System.Security.AccessControl.DirectorySecurity
$acl.SetOwner($builtin_administrators)
$acl.SetGroup($builtin_administrators)
$acl.SetAccessRuleProtection($true, $false)
$acl.AddAccessRule(
	[System.Security.AccessControl.FileSystemAccessRule]::new(
		"NT AUTHORITY\SYSTEM",
		"FullControl",
		"ContainerInherit, ObjectInherit",
		"None",
		"Allow" ) )
$acl.AddAccessRule(
	[System.Security.AccessControl.FileSystemAccessRule]::new(
		$builtin_administrators,
		"FullControl",
		"ContainerInherit, ObjectInherit",
		"None",
		"Allow" ) )
$acl.AddAccessRule(
	[System.Security.AccessControl.FileSystemAccessRule]::new(
		"BUILTIN\Users",
		"ReadAndExecute, Synchronize",
		"ContainerInherit, ObjectInherit",
		"None",
		"Allow" ) )
$acl | fl

$c_app_dirpath = "C:\app"

[System.IO.FileSystemAclExtensions]::Create($c_app_dirpath, $acl)
Get-Acl $c_app_dirpath | fl

# Path   : Microsoft.PowerShell.Core\FileSystem::C:\app
# Owner  : BUILTIN\Administrators
# Group  : BUILTIN\Administrators
# Access : NT AUTHORITY\SYSTEM Allow  FullControl
#          BUILTIN\Administrators Allow  FullControl
#          BUILTIN\Users Allow  ReadAndExecute, Synchronize
# Audit  :
# Sddl   : O:BAG:BAD:P(A;OICI;FA;;;SY)(A;OICI;FA;;;BA)(A;OICI;0x1200a9;;;BU)

mkdir "$c_app_dirpath\bin"
```
<br/>

# Settings pertaining to user profile

## Don't send my typing into the start menu to Bing without asking

### Win-R -> cmd.exe
```CMD
reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Search /v BingSearchEnabled
rem reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Search /v BingSearchEnabled /t REG_DWORD /d 0
```

## Disambiguate folders

### Win-R -> cmd.exe
```CMD
(set lodoc=%USERPROFILE%\Documents)
(set not_onedrive=00 THIS IS NOT OneDrive)
pushd "%lodoc%" && (
if not exist "%not_onedrive%" mkdir "%not_onedrive%"
if not exist "%not_onedrive%.txt" echo "[shrug emoji]" >"%not_onedrive%.txt"
dir & popd)
```

## Explorer settings

### Win-E (open Explorer)
```
View -> Show -> File name extensions
... -> Options
	General tab
	View tab
		Advanced settings - Files and Folders
			[check] Display the full path in the title bar
			[uncheck] Hide empty drives
			[uncheck] Hide extensions for known file types
			[uncheck] Hide folder merge conflicts
			[check] Launch folder windows in a separate process
			[uncheck] Use Sharing Wizard
		Advanced settings - Navigation pane
			[check] Always show availablility status
			[check] Expand to open folder
			[check] Show all folders
			[check] Show This PC
```

### Win-X -> Settings
```
System
	Display
		Scale & layout
			Scale [adjust to preference]
	Notifications
		Apps
			[off] Suggested
		Additional settings
			[uncheck] Show the Windows welcome experience after updates
			[uncheck] Suggest ways to get the most out of Windows
			[uncheck] Get tips and suggestions when using Windows
	Nearby sharing
		[turn off] Nearby sharing
Personalization
	Start
		Layout
			-> set to 'More pins'
	Colors
		Choose your mode
			Dark
		Accent color
			-> set to 'Automatic'
	Lock screen
		Personalize your lock screen
			[select, drop down] Picture
				[select] Choose a photo
				[uncheck] Get fun facts, tips, tricks, and more on your lock screen
	Start
		Layout
			[select] More pins
		[set on] Show recently added apps
		[set on] Show most used apps
		Folders
			[configure as desired]
	Taskbar
		Taskbar items
			Search
				[set to] Hide
			[turn off] Widgets
			[turn off] Chat
		System tray icons
		Other system tray icons
		Taskbar behaviors
			[check] Automatically hide the taskbar
	Device usage
		-> set all to 'Off'
Accessibility
	Interaction
		Keyboard
			[turn off] Sticky keys
			Sticky keys (configuration sub-page)
				[turn off] Keyboard shortcut for Sticky keys
			[turn off] Filter keys
			Filter keys (configuration sub-page)
				[turn off] Keyboard shortcut for Filter keys
			[turn off] Toggle keys
			On-screen keyboard, access keys, and Print screen
				[turn on] Underline access keys
Apps
	Apps for websites
		-> turn all off
	Optional features
		[uninstall] Internet Explorer mode
	Related settings
		More Windows features
			[check] Hyper-V
			[check] Virtual Machine Platform
			[check] Microsoft Defender Application Guard
			[check] Telnet client
			[check] Windows Sandbox
			[uncheck] Windows Subsystem for Linux (this is WSL1)
			[uncheck] Work folders client
		This will require restart.
Time & Language
	Typing
		Advanced keyboard settings tab
			Input language hot keys
				To turn off Caps Lock
					[change to] Press the SHIFT key
				Hot keys for input languages
					[select] Action: Between input languages
					[click] Change Key Sequnce...
						Switch Input Language
							Previously set to Left Alt + Shift
							[change to] (Not assigned)
						Switch Keyboard Layout
							[change to] (Not assigned)
```
## Win-E -> Alt-D -> "Control Panel"
```
View by
	[select] Small icons
		(Weird, this setting seems to no longer stick)
	Ease of Access Center
		[uncheck] Always read this section aloud
		[uncheck] Always scan this section
		Make the computer easier to see
			[uncheck] Turn on or off High Contrast when
			    ALT + left SHIFT + PRINT SCREEN is pressed
			OK
		Make the mouse easier to use
			Set up Mouse keys
				[uncheck] Turn on Mouse Keys with
			        left ALT + left SHIFT + NUM LOCK
			OK
		Make it easier to focus on tasks
			Make it easier to type
				[uncheck] Turn on Toggle Keys by holding down the
			        NUM LOCK key for 5 seconds
		Adjust time limits and flashing visuals
			[check] Turn off all unnecessary animations (when possible)
			How long should Windows notification dialog boxes stay open
				[select] 30 seconds
			OK
	Mouse Properties
		Pointer Options tab
			[check] Display pointer trails
			[uncheck] Hide pointer while typing
			[check] Show location of  pointer when I press the CTRL key
	Power Options
		[select] Show additional plans
			[Consider selecting a different plan]
```

## Set up Edge browser user profiles

### Additional profiles

Create "misc" and "social":

* Click on current profile -> Other profiles -> Add profile

### For each (initial and new) Edge browser profile

```
click on '...' in upper left -> Settings

Your profile
	click on "..." to the right of profile name -> Edit
		Select a unique image
		Consider renaming profile

	Profiles (Settings section on left)
		Microsoft Rewards
			[turn off] Microsoft Rewards
		Payment info
			[turn off] (OOO) Show Buy now, pay later option on sites when you shop
			[turn off] Save and fill payment info
			[turn off] Show Express checkout on sites when you shop
		Profile preferences
			[turn off] Automatic sign in on Microsoft Edge
			Automatic profile switching
				-> consider if you want this off or on. Useful for work.
			Default profile for external links
				-> set to "misc"
			[turn off] Allow single sign-on for work or school sites using this profile
			[turn off] Allow single sign-on for Microsoft personal sites using this profile
		Share browsing data with other Windows features
			[turn off] Share browsing data with other Windows features

	Privacy, search, and services (Settings section on left)
		Tracking prevention
			-> set to Strict
		Clear browsing data
			Choose what to clear every time you close the browser
				Cookies and other site data (and other sections)
					-> consider turning this on for "misc" profiles from which you will not log on to any sites
		Privacy
			[turn on] Send "Do Not Track" requests
			[turn off] Allow sites to check if you have payment methods saved
		Optional diagnostic data
			[turn off] Help improve Microsoft products by sending optional diagnostic data about how you use the browser, websites you visit, and crash reports
		Search and service improvement
			[turn off] Help improve Microsoft products by sending the results from searches on the web
		Personalization & advertising
			[turn off] Allow Microsoft to save your browsing activity including history, usage, favorites, web content, and other browsing data to personalize Microsoft Edge and Microsoft services like ads, search, shopping and news.
		Security
			Manage certificates
				-> if you're brave
			[turn on] Microsoft Defender SmartScreen
			[turn on] Website typo protection
		Services
			[turn off] Use a web service to help resolve navigation errors
			[turn off] Suggest similar sites when a website can't be found
			[turn off] Save time and money with Shopping in Microsoft Edge
			[turn off] (OOO) Get notified when creators you follow post new content
			[turn off] Show suggestions to follow creators in Microsoft Edge
			[turn off] Show opportunities to support causes and nonprofits you care about
			[turn off] Get notifications of related things you can explore with Discover
			[turn off] Let Microsoft Edge help keep your tabs organized
			Address bar and search
				[turn off] Show me search and site suggestions using my typed characters
				Search engine used in the address bar.
					-> Consider changing

	Appearance (Settings section on left)
		Customize appearance
			-> Choose whatever you want for this profile
		Customize toolbar
			[turn on] Show vertical tabs for all current browser windows
			Show favorites bar
				 -> Always
			Select which buttons to show on the toolbar:
				Home button
					(we'll set this up later)
				[turn on] Downloads button
				[turn on] Math Solver button
				[turn on] Web capture button
		Context menus
			Right-click menu
				[turn off] Show smart actions
				Hover menu
					[turn off] Show hover menu on image hover
			Mini menu on text selection
				[turn off] Show smart actions

	Sidebar (Settings section on left)
		Customize sidebar
			[turn off] Always show sidebar
			[turn off] Personalize my top sites in customize sidebar
		App and notification settings
			[turn off] Allow sidebar apps to show notifications

	Start, home, and new tabs (Settings section on left)
		When Edge starts
			Open these pages:
				Add a new page
					about:blank
		Home button
			[turn off] Show home button on the toolbar
			Set what the home button opens below:
				-> about:blank
		New tab page
			Customize your new tab page layout and content
				* don't click this
			[turn off] Preload the new tab page for a faster experience

	Share, copy and paste (Settings section on left)
		-> Plain text

	Cookies and site permissions (Settings section on left)
		Cookies and data stored
			Manage and delete cookies and site data
				[turn on] (OOO) Block third-party cookies
				Allow sites to save and read cookie data (recommended)
					-> Consider turning off
				[turn off] Preload pages for faster browsing and searching

	Default browser (Settings section on left)
		Nothing

	Downloads (Settings section on left)
		Open Office files in the browser
			-> Consider turning off
	
	Family (Settings section on left)
		Nothing
	
	Languages (Settings section on left)
		Share additional OS regional format
			Share additional operating system region
				-> Never

	Printers (Settings section on left)
		Nothing

	System and performance (Settings section on left)
		Startup boost
			-> turn off (this setting seems to be system- or user-wide)
		Continue running background extensions and apps when Microsoft Edge is closed
			-> turn off (this setting seems to be system- or user-wide)
		Use hardware acceleration when available
			-> Consider turning off (this setting seems to be system- or user-wide)

Hit F12
	If you get a popup confirmation
		Remember my decision -> check
		[click] Open DevTools
	Vertical '...' menu in upper right
		Dock side
			[click] Leftmost option to pop out DevTools into separate window
	[uncheck] Show Welcome after each update
	Close dev tools window

====^^^^====^^^^==== For each (initial and new) Edge browser profile ====^^^^====^^^^====
```
***End of 'For each Edge browser profile'***

## Set up a SecretStore SecretVault for storing the WSL2 Ubuntu user password

### Install PowerShell 7 (or later)

See [30 powershell 7 or later](./30_powershell_7_or_later.md).

### Win-X -> Terminal -> PowerShell 7
```PowerShell
Find-Module -Name Microsoft.PowerShell.SecretStore
# Version Name                             Repository Description
# ------- ----                             ---------- -----------
# 1.0.6   Microsoft.PowerShell.SecretStore PSGallery  This PowerShell module is an extension v…

Install-Module -Name Microsoft.PowerShell.SecretStore

Register-SecretVault -Name DefaultVault_SecretStore -ModuleName Microsoft.PowerShell.SecretStore -DefaultVault
Get-SecretVault -Name DefaultVault_SecretStore | fl

# Actually create the SecretStore vault. This should ask for a password.
Get-SecretStoreConfiguration

# Add the secret for the Ubuntu user password.
# This will ask for a username and password, but the username doesn't matter.
Set-Secret -Vault DefaultVault_SecretStore -Name 'wsl Ubuntu user' -Secret (Get-Credential)
Get-SecretInfo

# To later get the plaintext password
(Get-Secret -Vault DefaultVault_SecretStore -Name 'wsl Ubuntu user').Password | ConvertFrom-SecureString –AsPlainText

dir $env:LOCALAPPDATA\Microsoft\PowerShell\secretmanagement\secretvaultregistry
```

## Windows applications

[uninstall] Teams

***End of 'Settings pertaining to user profile'***

## Sysinternals

https://download.sysinternals.com/files/SysinternalsSuite.zip

Extract to c:\app\bin

### Win-R (Run)
```PowerShell
explorer.exe /select,c:\app\bin\procexp64.exe
```

Right-click on `procexp64.exe`

Pin to Start

## WSL2 (optional)
```PowerShell
wsl --help
wsl --status
wsl --list --online
wsl --install
```
### Win-X -> Terminal -> Ubuntu

Pick a strong user password. Keep it in Notepad, unsaved, for now

```Bash
touch $HOME/.hushlogin
sudo visudo
sudo sh -c 'apt update && apt upgrade -y'
```

The rest of the set up Ubuntu belongs in another document.

### SecretStore SecretVault for storing the WSL2 Ubuntu user password

### Win-X -> Terminal -> PowerShell 7
```
Find-Module -Name Microsoft.PowerShell.SecretStore

# Version Name                             Repository Description
# ------- ----                             ---------- -----------
# 1.0.6   Microsoft.PowerShell.SecretStore PSGallery  This PowerShell module is an extension v…
```

```
Install-Module -Name Microsoft.PowerShell.SecretStore

Register-SecretVault -Name DefaultVault_SecretStore -ModuleName Microsoft.PowerShell.SecretStore -DefaultVault

Get-SecretVault -Name DefaultVault_SecretStore | fl
```
Actually create the SecretStore vault. This should ask for a password.

Choose a strong one, as it's not clear what password hashing function, work factor,
or anti-hammering protection is applied.
```
Get-SecretStoreConfiguration
```
Add the secret for the Ubuntu user password.

This should ask for a username and password, but I don't think the username actually matters.
```PowerShell
Set-Secret -Vault DefaultVault_SecretStore -Name 'wsl Ubuntu user' -Secret (Get-Credential)
Get-SecretInfo
```

### To later retrieve the plaintext password
```PowerShell
(Get-Secret -Vault DefaultVault_SecretStore -Name 'wsl Ubuntu user').Password | ConvertFrom-SecureString –AsPlainText

dir $env:LOCALAPPDATA\Microsoft\PowerShell\secretmanagement\secretvaultregistry
```

## After basic apps are installed

### Win-X -> System -> Advanced System Settings -> Advanced tab -> [click] Environment Variables

**IMPORTANT**: Modifying the Registry will mess up your system.

I choose to be bold and take risks here.

Move a bunch of junk from Path to Path-not

* Not having LOCALAPPDATA\Microsoft\WindowsApps in Path had the effect of breaking the default
terminal profile for WSL2 Ubuntu, which specifies the command line as simply 'ubuntu.exe'. Adjusting
the profile to refer to %LOCALAPPDATA%\Microsoft\WindowsApps\ubuntu.exe instead seems to have
fixed it.

Result:

### System Variables
```
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path-not
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
    Path-not    REG_EXPAND_SZ    %SYSTEMROOT%\System32\WindowsPowerShell\v1.0\;C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common

reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
    Path    REG_EXPAND_SZ    %SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\OpenSSH\;
```

### User variables
```
reg query HKCU\Environment /v Path
HKEY_CURRENT_USER\Environment
    Path    REG_EXPAND_SZ    C:\app\bin

reg query HKCU\Environment /v Path-not2
HKEY_CURRENT_USER\Environment
    Path-not2    REG_EXPAND_SZ    %USERPROFILE%\AppData\Local\Microsoft\WindowsApps;
```

## Other stuff

### Install local printers
