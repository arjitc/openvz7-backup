#!/bin/bash
VMID=$1
# Known snapshot ID
SNAPSHOT_ID=$2
DUMP_PATH="/vz/dumptmp"

VE_PRIVATE=$(vzlist -H -o private $1)

# Take a snapshot without suspending a CT and saving its config
/usr/sbin/vzctl snapshot $1 --id $SNAPSHOT_ID --skip-suspend

# Perform a backup using your favorite backup tool
# (cp is just an example)
mkdir $DUMP_PATH/$VMID
cp $VE_PRIVATE/root.hdd/* $DUMP_PATH/$VMID
cp /etc/vz/conf/$VMID.conf $DUMP_PATH/$VMID/
cd $DUMP_PATH/$VMID/ && /usr/bin/tar -czf /vz/dump/$SNAPSHOT_ID.tar.gz . && rm -rf $DUMP_PATH/$VMID
/usr/sbin/vzctl snapshot-delete $1 --id $SNAPSHOT_ID
