#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

TODAY=`date +%Y%m%d`
APP="../conf/app"
CONFIG="../conf/config"
DRYRUN=0
CURRENT_DIR=`dirname "$0"`
LOCK_FILE=/var/lock/easybackup.lock

#SOURCE ../conf/app
. $CURRENT_DIR/$APP


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
	echo "	-p	Profile File to use.  Defaults to conf/config"
	echo "	-h	Output this help menu"
	echo "	-v	Print Version Number"
	echo "	-d	Dry Run - output commands only"
	echo "Version: $VERSION"
	echo "Website: $WEBSITE"
}

while getopts 'hvdp:' opt; do
	case "$opt" in
	h)
		usage
		exit 0
		;;
	v)
		echo $VERSION
		exit 0
		;;
	d)
		DRYRUN=1
		;;
	p)
		CONFIG="../conf/${OPTARG}"
		LOCK_FILE=/var/lock/easybackup-${OPTARG}.lock
		;;
	esac
done

echo "Current Dir: $CURRENT_DIR"
echo "Config: ${CONFIG}"

if [ ! -f "$CURRENT_DIR/$CONFIG" ]
then
	echo "Config File does not exist"
	exit 1
fi


#Source config file
. $CURRENT_DIR/$CONFIG


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
RM_CMD="ls -1trd $DESTINATION/* | tail -n +${NUM_BACKUPS} | xargs -d '\n' rm -rf --"
echo "`timestamp` COMMAND: $RM_CMD"
if [ $DRYRUN -ne 1 ] 
then
	eval $RM_CMD
	if [ $? -ne 0 ]
	then
        	echo "`timestamp` Aborting"
	        cleanup
        	exit 1
	fi
fi

if [ -d "$DESTINATION/$TODAY" ]
then
	echo "`timestamp` Destination directory $DESTINATION/$TODAY already exists"
	exit 1
fi
PREVIOUS_BACKUP=`ls -tr $DESTINATION | head -n 1`


echo "`timestamp` Copying Previous backup into $DESTINATION/$TODAY"
CP_CMD="cp -aflrP $DESTINATION/$PREVIOUS_BACKUP $DESTINATION/$TODAY"
echo "`timestamp` COMMAND: $CP_CMD"

if [ $DRYRUN -ne 1 ]
then
	$CP_CMD
	if [ $? -ne 0 ]
	then
        	echo "`timestamp` Aborting"
	        cleanup
        	exit 1
	fi
fi

echo "`timestamp` Rsyncing data from source to $DESTINATION/$TODAY"
RSYNC_CMD="rsync -av --delete $SOURCE/ $DESTINATION/$TODAY"
echo "`timestamp` COMMAND: $RSYNC_CMD"

if [ $DRYRUN -ne 1 ]
then
	$RSYNC_CMD
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

