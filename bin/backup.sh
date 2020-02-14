#!/bin/bash

TODAY=`date +%Y%m%d`
APP="../conf/app"
CONFIG="../conf/config"
DRYRUN=0

#SOURCE ../conf/app
. $APP

#timestamp - Gets current time
timestamp() {
	echo `date "+%Y-%m-%d %H:%M:%S"`
}

#cleanup - removes lock file
cleanup() {
	unlink $LOCK_FILE
}

usage() {
	echo "usage: backup.sh"
	echo "	--help		Output this help menu"
	echo "	--version	Print Version Number"
	echo "	--dry-run	Dry Run - output commands only"
	echo "Version: $VERSION"
	echo "Website: $WEBSITE"
}

if [ "$1" == "--help" ]
then
	usage
	exit 0
fi
if [ "$1" == "--version" ]
then
	echo $VERSION
	exit 0
fi

if [ "$1" == "--dry-run" ]
then
	DRYRUN=1
fi

if [ ! -f "$CONFIG" ]
then
	echo "Config File does not exist"
	exit 1
fi

#Source config file
. $CONFIG

if [ ! -d "$DESTINATION" ]
then
	echo "Destination $DESTINATION doesn't exists. Aborting"
	exit 1
fi

if [ -z "$SOURCE" ]
then
	echo "SOURCE is not set. Aborting"
	exit 1
fi

if [ -z "$NUM_BACKUPS" ]
then
	echo "NUM_BACKUPS is not set. Aborting"
	exit 1
fi

if [ -f "$LOCK_FILE" ]
then
	echo "Lock file $LOCK_FILE exists. Aborting"
	exit 1
fi

echo "`timestamp` Starting backup"
if [ $DRYRUN -eq 1 ] 
then
	echo "`timestamp` Dry Run"
fi

touch $LOCK_FILE

echo "`timestamp` Remove Old Backups"
RM_CMD=""
echo "`timestamp` COMMAND: $RM_CMD"
if [ $DRYRUN -ne 1 ] 
then
	#$RM_CMD
	if [ $? -ne 0 ]
	then
        	echo "`timestamp` Aborting"
	        cleanup
        	exit 1
	fi
fi

echo "`timestamp` Creating backup folder $DESTINATION/$TODAY"
MKDIR_CMD="mkdir $DESTINATION/$TODAY"
echo "`timestamp` COMMAND: $MKDIR_CMD"

if [ $DRYRUN -ne 1 ]
then
	#MKDIR_CMD
	if [ $? -ne 0 ]
	then
		echo "`timestamp` Aborting"
		cleanup
		exit 1
	fi
fi

echo "`timestamp` Copying Previous backup into $DESTINATION/$TODAY"
CP_CMD="time cp -flrP $PREVIOUS_BACKUP $DESTINATION/$TODAY"
echo "`timestamp` COMMAND: $CP_CMD"

if [ $DRYRUN -ne 1 ]
then
	#CP_CMD
	if [ $? -ne 0 ]
	then
        	echo "`timestamp` Aborting"
	        cleanup
        	exit 1
	fi
fi

echo "`timestamp` Rsyncing data from source to $DESTINATION/$TODAY"
RSYNC_CMD="time rsync -av --delete $SOURCE $DESTINATION/$TODAY"
echo "`timestamp` COMMAND: $RSYNC_CMD"

if [ $DRYRUN -ne 1 ]
then
	#RSYNC_CMD
	if [ $? -ne 0 ]
	then
        	echo "`timestamp` Aborting"
	        cleanup
        	exit 1
	fi
fi

echo "`timestamp` Finished Backup"
cleanup
exit 0

