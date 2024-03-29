# EasyBackup
[![Build Status](https://github.com/IGBIllinois/EasyBackup/actions/workflows/main.yml/badge.svg)](https://github.com/IGBIllinois/EasyBackup/actions/workflows/main.yml)

* Backup program using rsync and hard links
* Very good at backing up large amounts (Many Terabytes) of data reliably.

## Requirements
* Rsync - [https://rsync.samba.org/](https://rsync.samba.org/)
* Bash - [https://www.gnu.org/software/bash/](https://www.gnu.org/software/bash/)

## Installation
* Install rsync if not already installed
* For Redhat/CentOS
```
yum install rsync
```
* For Debian/Ubuntu
```
apt-get install rsync
```
* Copy conf/config.dist to conf/config
```
cp conf/config.dist conf/config
```
* Edit conf/config and specify SOURCE, DESTINATION, and NUM_BACKUPS
* An example is below
```
SOURCE=root@source.example.com:/source_directory
DESTINATION=/backups/destination_directory
NUM_BACKUPS=30
LOCK_FILE=/var/lock/easybackup.lock
```
* If the SOURCE is a remote host, create ssh keys 
```
ssh-keygen
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

