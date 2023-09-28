# Dev Environment Set Up

First, do [basic set up](./00_basic_windows.md).

## GitHub Desktop

Practically impossible to find from the main site:
https://desktop.github.com/

Open source: https://github.com/desktop/desktop

## Git for windows

https://git-scm.com/downloads
to C:\app\git

## Rust dev env

Download `rustup-init.exe` from [rust-lang.org](https://www.rust-lang.org/tools/install).

At the time of this writing, this binary is not signed.
Check what you downloaded at [virusttotal](https://virusttotal.com/).

The `CARGO_HOME` path will get embedded in the built binaries. Set env vars `CARGO_HOME`
and `RUSTUP_HOME` to something shorter than the default `%USERPROFILE%\.cargo` and
`%USERPROFILE%\.rustup`. For example, `C:\u\cargo` and `C:\u\rustup`.

## After basic apps are installed
```
reg query HKCU\Environment /v Path
HKEY_CURRENT_USER\Environment
    Path    REG_SZ    C:\app\bin;C:\app\git\bin;C:\u\cargo\bin;

cmd.exe /c set | findstr /i "^Path=" & pause
    Path=C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;
    C:\Windows\System32\OpenSSH\;C:\app\bin;C:\app\git\bin;C:\u\cargo\bin;C:\Users\marsh\app\vscode\bin
```

### System Variables
```
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path
    HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
        Path    REG_EXPAND_SZ    %SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\OpenSSH\;
```
### User variables
```
reg query HKCU\Environment /v Path
    HKEY_CURRENT_USER\Environment
        Path    REG_EXPAND_SZ    C:\app\git\bin;C:\app\bin;%;C:\u\cargo\bin;
```

##  Nushell
```
cargo install nu
    Finished release [optimized] target(s) in 1m 19s
  Installing C:\Users\marsh\.cargo\bin\nu.exe
   Installed package `nu v0.82.0` (executable `nu.exe`)
```

##  Ripgrep
```
cargo install ripgrep
    Finished release [optimized + debuginfo] target(s) in 1m 19s
  Installing C:\Users\marsh\.cargo\bin\rg.exe
   Installed package `ripgrep v13.0.0` (executable `rg.exe`)
```
