#!/bin/bash
VMID=$1
# Known snapshot ID
SNAPSHOT_FILE=$2
SNAPSHOT_PATH="/vz/dump"
TEMP_DUMP_PATH="/vz/dumptmp"
# stop VPS and set it to disabled so it does not boot during this process
/usr/sbin/vzctl stop $1 --fast
/usr/sbin/vzctl set $1 --disabled=yes --save

# Perform a backup using your favorite backup tool
# (cp is just an example)
mkdir $TEMP_DUMP_PATH/$VMID
/usr/bin/tar -C $TEMP_DUMP_PATH/$VMID -zxvf $SNAPSHOT_PATH/$SNAPSHOT_FILE
cd $TEMP_DUMP_PATH/$VMID/ && mv $VMID.conf /etc/vz/conf/ && mv * /vz/private/$VMID/

/usr/sbin/vzctl set $1 --disabled=no --save
/usr/sbin/vzctl start $1

echo "DONE"
