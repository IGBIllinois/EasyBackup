# EasyBackup
Rsync Backup Program

## Installation
* Create local user that this program will run as
```
useradd -d /usr/local/EasyBackup -U -r -s /bin/nologin easybackup
```
* Create permissions on destination folder for the user
```
chown easybackup.easybackup /backups
```

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

