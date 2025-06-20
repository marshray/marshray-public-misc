# Ubuntu New Set Up

## Serial console

Documentation resources:

`man 8 systemd-getty-generator`

https://www.kernel.org/doc/Documentation/admin-guide/kernel-parameters.txt <br/>
https://www.kernel.org/doc/Documentation/admin-guide/serial-console.rst <br/>
https://0pointer.de/blog/projects/serial-console.html <br/>

The kernel boot line can specify a serial console.<br/>

`console=ttyS0,115200` means start a console on the first serial device, 115200 baud, 8 bits, no parity,
XON/XOFF flow control.<br/>
This is a typical configuration.

`console=ttyS0,115200n8r` means start a console on the first serial device, 115200 baud, 8 bits,
no parity, RTS (hardware) flow control. Unfortunately, hardware flow control seems block the boot process if no terminal is connected to the serial port.

You can also specify multiple consoles:<br/>

`console=ttyS0,115200n8r console=tty0`<br/>

With `tty0` being the first `vt` console (Ctrl-Alt-F1).

`systemd` is said to automatically let you login to a serial console if one is specified.
But these commands may be helpful:

```sh
sudo -i
systemctl enable serial-getty@ttyS0.service
systemctl start serial-getty@ttyS0.service
```

## Enable the grub boot menu

With a local keyboard you may be able to edit the kernel boot line as it boots, but you
probably don't want to have to do that every time. Specifying `GRUB_CMDLINE_LINUX` persists
the kernel boot line.

```sh
sudo -i
cd /etc/default
cp -a grub grub.0
cp -a grub grub.1

vim grub.1
# vvvvvvvvvvvvvvv edits to grub.1 vvvvvvvvvvvvvvv

# Show the menu for 3 seconds
GRUB_TIMEOUT_STYLE=menu
GRUB_TIMEOUT=3

GRUB_CMDLINE_LINUX="console=ttyS0,115200"

# Uncomment to disable graphical terminal
GRUB_TERMINAL=console
# ^^^^^^^^^^^^^^^ edits to grub.1 ^^^^^^^^^^^^^^^

cp -a grub.1 grub

update-grub
```

## Booting hangs on network availability

By default, Ubuntu Server boot seems to wait for up to 2 minutes waiting for the network links to
come up and obtain an IP address.

While this probably makes sense for most servers, it doesn't for all.

To disable this:

```sh
sudo -i
systemctl disable systemd-networkd-wait-online.service
systemctl mask systemd-networkd-wait-online.service
```

## Home directory permissions

If you don't want your home directory group-readable:

```sh
chmod -R go-rwx ~
```

## Too minimial for a basic network connection

If you selected a 'minimial install', you may find it minimal indeed.

```sh
sudo unminimize
```

It's probably possible to make this work from the original install media, but I had removed the USB drive with the ISO after boot. You'll probably want networking for the latest packages anyway.

```sh
ip a
```

Showed that networking was not working for me. I think the 'minimal install' option assumes the VM host will give it its network configuration on boot.

It was fun having to type all this perfectly without an editor.

```sh
sudo -i   # i.e., this rest done as root
cd ~
umask 077
cat <<EOF >99_config.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s25:
      dhcp4: true
EOF
cp -a 99_config.yaml /etc/netplan
netplan apply
```

## Updates and favorite packages

```sh
sudo -i   # i.e., this rest done as root
apt purge popularity-contest
apt update
apt install apt-transport-https
apt upgrade -y
apt install iputils-arping net-tools gnupg vim
```

On older x86_64 Ubuntu the i386 architecture was supported for compatibility. Here's how to remove it:

```sh
sudo dpkg --remove-architecture i386
```

## More favorite packages

```sh
sudo apt install bing git gitk git-doc htop sqlite3 sqlite3-doc sqlite3-tools tmux unzip zip lm-sensors
```

## Basic customization

```sh
# As user
(umask 0177; touch ~/.hushlogin)
sudo sh -c 'umask 0133; touch /root/.hushlogin /etc/skel/.hushlogin'
```

## SSH

`man 5 ssh_config`

Check out the capabilities of the current version.
```sh
for w in `ssh -Q help`; do
    echo vvvv ssh -Q $w vvvv
    ssh -Q $w
    echo '^^^^' ssh -Q $w '^^^^'
    echo
done
```

### Regenerate SSH host key

```sh
sudo -i
cd /etc/ssh
mkdir old-keys && mv ssh_host_* old-keys
ssh-keygen -t ecdsa -b 521 -C `cat /etc/hostname` -f ssh_host_key_p521
# no passphrase

cp -a sshd_config sshd_config.0
cp -a sshd_config sshd_config.1
vim sshd_config.1
# vvvvvvvvvvvvvv
KexAlgorithms ecdh-sha2-nistp521
HostKeyAlgorithms ecdsa-sha2-nistp521
HostKey /etc/ssh/ssh_host_key_p521
# ^^^^^^^^^^^^^^
cp -a sshd_config.1 sshd_config
service ssh restart
```

### Change sshd port

Question: Does your desktop or laptop machine really need `sshd` running at all?

For example, IPv4 address `192.168.333.333` and port `77777`
(These are invalid, pick real values, write them down.)

```sh
sudo -i
mkdir /etc/systemd/system/ssh.socket.d
cat >/etc/systemd/system/ssh.socket.d/listen.conf <<EOF
[Socket]
ListenStream=
ListenStream=192.168.333.333:77777
EOF
systemctl daemon-reload
systemctl restart ssh.socket
tail -f /var/log/syslog
netstat -anop --tcp
```

## Disable swap

***NOTE*** Opinions vary on whether disabling swap is a good idea. I have seen
it allow one to recover a server from a death spiral, but usually it just seems
to prolong the inevitable.

Consider:

```sh
sudo vim /etc/fstab
# comment out the line that mounts the swap file
```

## Disabling IPv6

Consider:

```sh
sudo vim /etc/sysctl.conf
```
Add setting `net.ipv6.conf.all.disable_ipv6 = 1`

## Reboot

```sh
sudo shutdown -r now
```

## Sudoers

I prefer some changes to sudoers:

```sh
sudo visudo
```

- I add `NOPASSWD:` before the last `ALL` on each privilege specification.
  I log in as a non-admin user for everyday work, and I don't think it's a good
  idea to enter your admin password whenever some app randomly asks for it.

- I set `Default secure_path="/usr/sbin:/usr/bin"`. Doing `ls -al /` in Ubuntu 24.04
  shows that `/sbin` and `/bin` are just symlinks to `/usr/sbin` and `/usr/bin`.

## Aptitude

It has a real learning curve, but it's what I've always used:

```sh
sudo sh -c 'apt install aptitude -y && aptitude'
```

`Ctrl-T` -> `Options` -> `Preferences`

- `uncheck` Automatically resolve dependencies of a package when it is selected
- `uncheck` Automatically fix broken packages before installing or removing
- `uncheck` Install recommended packages automatically

Save and quit: `q` `q` `y`

## Automatic login to graphical desktop

### ***NOTE*** -- I haven't tested this in many releases.

Consider:

```sh
sudo vim /etc/gdm3/custom.conf
```

Edit `ExecStart` line:

```sh
ExecStart=-/sbin/agetty --autologin someuser --noclear %I $TERM
```

## 

```sh
```

## 

```sh
```

## As regular user


## Removing unneeded packages

```sh
sudo apt autoremove -y
```

## 

```sh
```

## 

```sh
```

## 

```sh
```

## 

```sh
```

## 

```sh
```
