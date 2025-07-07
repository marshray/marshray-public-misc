# SSH

## Authorize one's key on another machine

```
# Something like this, NOT yet tested
# cat mypubkeyfile.pub | ssh user@machine 'umask 077; [ -d ~ ] && { [ -d ~/.ssh ] || mkdir ~/.ssh } && cat >>~/.ssh/authorized_keys'
```
