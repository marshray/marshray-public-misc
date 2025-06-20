# SSH user key

Pick a strong user password.

Generate your user key:

### Win-X -> Terminal -> PowerShell 7
```PowerShell
cd $env:USERPROFILE
ssh-keygen -t ecdsa -b 521 -C "$($env:USERNAME)@$($env:COMPUTERNAME.ToLower())"
```

Accept the default location (`$env:USERPROFILE\.ssh\id_rsa`).

Paste in the strong password.

To protect the password while starting the ssh key agent every time you login, see [Key-based authentication in OpenSSH for Windows](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement). Process summarized here.

To observe the PUBLIC key in this example. 

PS C:\Users\marsh> cat .\.ssh\id_rsa.pub
ssh-rsa AAA...s4rz4Aw== marsh@piplup
P

Powershell as Admin:

### Win-X -> Terminal (Admin) -> PowerShell 7
```PowerShell
Get-Service ssh-agent | Set-Service -StartupType Automatic
Start-Service ssh-agent
Get-Service ssh-agent
```

Observe that that `Status` is `Running`:
```
Status   Name               DisplayName
------   ----               -----------
Running  ssh-agent          OpenSSH Authentication Agent
```

Now, as your regular user:

### Win-X -> Terminal -> PowerShell 7
```PowerShell
cd $env:USERPROFILE
ssh-add .ssh\id_rsa
```

Paste in the strong password. It should respond something like:<br/>
`Identity added: .ssh\id_rsa (user@host)`

To confirm:
```PowerShell
ssh-add -l
```
It should respond something like:<br/>
`4096 SHA256:6mLb4ubGbYe5NFfJIW99Dz+bwsnANj6Q/BBMeXm+c8M user@host (RSA)`

