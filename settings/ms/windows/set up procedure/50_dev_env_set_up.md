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

## Nvidia

The Nvidia video card driver install edited the system `Path` to put
* C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common

That's 112 bytes of junk in the environment of every process just to locate four dlls.
Also, a bit ridiculous to still be using a 32-bit compatibility directory in this
day and age. But you do you, Nvidia.

### PATH

The Nvidia CUDA install edited the system `Path` to put
* C:\app\nvidia\cuda\v12.2\bin
* C:\app\nvidia\cuda\v12.2\libnvvp
ahead of even the Windows system directories. (Gee thanks guys real helpful).
The 'libnvvp' directory is particularly useless, it contains only `nvvp.exe`
and `eclipse.exe`, neither of which run without a Java runtime available.

It also appends to the system `Path`
* C:\Program Files\NVIDIA Corporation\Nsight Compute 2023.2.2\
This directory doesn't even contain executables, just a couple of .bat files that have
start menu items anyway.

It also created the variables `CUDA_PATH` and `CUDA_PATH_V12_2` with the value `C:\app\nvidia\cuda\v12.2`.

But my development tools seemed to look for the variable `CUDA_ROOT` for some reason.

In any case, `%CUDA_PATH%\bin` needs to be in the `Path``.

## After dev apps are installed
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
        Path    REG_EXPAND_SZ    %SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SystemRoot%\System32\OpenSSH;C:\Program Files\PowerShell\7\
```
### User variables
```
reg query HKCU\Environment /v CARGO_HOME
HKEY_CURRENT_USER\Environment
    CARGO_HOME    REG_SZ    C:\u\cargo

reg query HKCU\Environment /v RUSTUP_HOME
HKEY_CURRENT_USER\Environment
    RUSTUP_HOME    REG_SZ    C:\u\rustup

reg query HKCU\Environment /v Path
    HKEY_CURRENT_USER\Environment
        Path    REG_EXPAND_SZ    C:\app\bin;
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
