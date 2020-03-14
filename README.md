# EasyBackup
![Travis](https://www.travis-ci.com/IGBIllinois/EasyBackup.svg?branch=master)

* Backup program using rsync and hard links
* Very good at backing up large amounts (Many Terabytes) of data reliably.

## Requirements
* Rsync - [https://rsync.samba.org/](https://rsync.samba.org/)
* Bash - [https://www.gnu.org/software/bash/](https://www.gnu.org/software/bash/)

## Installation
* Copy conf/config.dist to conf/config
```
cp conf/config.dist conf/config
```
* Edit conf/config and specify SOURCE, DESTINATION, and NUM_BACKUPS
* If the SOURCE is a remote host, create ssh keys 
```
ssh-copy-id root@sourcehost.com
```
* Copy example cron file from conf/cron.dist to conf/cron
```
cp conf/cron.dist conf/cron
```
* Symlink conf/cron to /etc/cron.d/easybackup
```
ln -s /usr/local/EasyBackup/conf/cron /etc/cron.d/easybackup
```

