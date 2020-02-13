#!/bin/bash

TODAY=`date +%Y%m%d`
CONFIG="../conf/config"

if [ ! -f "$CONFIG" ]
then
	echo "Config File does not exist"
	exit 1
fi

. $CONFIG

if [ ! -d "$DESTINATION" ]
then
	echo "Destination $DESTINATION doesn't exists"
	exit 1

fi
