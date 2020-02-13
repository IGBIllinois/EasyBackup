#!/bin/bash

SOURCE=
DESTINATION=
NUM_BACKUPS=
LOCK_FILE=/var/lock/easybackup.lock
TODAY=`date +%Y%m%d`

if [ ! -d "$DESTINATION" ]
then
	echo "Destination $DESTINATION doesn't exists";

fi
