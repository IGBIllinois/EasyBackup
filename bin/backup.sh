#!/bin/bash

TODAY=`date +%Y%m%d`
CONFIG="../conf/config"


timestamp() {
	echo `date "+%Yi-%m-%d %H:%M:%S"`
}

cleanup() {
	unlink $LOCK_FILE
}

if [ ! -f "$CONFIG" ]
then
	echo "Config File does not exist"
	exit 1
fi

#Source config file
. $CONFIG

if [ ! -d "$DESTINATION" ]
then
	echo "Destination $DESTINATION doesn't exists"
	exit 1
fi

if [ -f "$LOCK_FILE" ]
then
	echo "Lock file $LOCK_FILE exists. Aborting"
	exit 1
fi

echo "`timestamp` Starting backup"
touch $LOCK_FILE

echo "`timestamp` Remove Old Backups"

echo "`timestamp` Creating backup folder $DESTINATION/$TODAY"
MKDIR_CMD="mkdir $DESTINATION/$TODAY"
echo "`timestamp` $MKDIR_CMD"
#MKDIR_CMD
if [ $? -ne 0 ]
then
	echo "`timestamp` Aborting"
	cleanup
	exit 1
fi

echo "`timestamp` Copying Previous backup into $DESTINATION/$TODAY"
CP_CMD="time cp -flrP $PREVIOUS_BACKUP $DESTINATION/$TODAY"
echo "`timestamp` $CP_CMD"
#CP_CMD
if [ $? -ne 0 ]
then
        echo "`timestamp` Aborting"
        cleanup
        exit 1
fi


echo "`timestamp` Rsyncing data from source to $DESTINATION/$TODAY"
RSYNC_CMD="time rsync -av --delete $SOURCE $DESTINATION/$TODAY"
echo "`timestamp` $RSYNC_CMD"
#RSYNC_CMD
if [ $? -ne 0 ]
then
        echo "`timestamp` Aborting"
        cleanup
        exit 1
fi


echo "`timestamp` Finished Backup"
cleanup
exit 0
