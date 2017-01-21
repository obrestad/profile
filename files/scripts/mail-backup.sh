#!/bin/bash

mailPath="/srv/mail"
mailSnap="/srv/mail-backup/snap"

if [ ! -e $mailSnap ]; then
	mkdir $mailSnap
fi

cd $mailSnap

last=$(ls -td 1* 2> /dev/null  | head -n 1)
laststatus=$?

# Print log info
TIME=$(date +%y%m%d-%H%M)
echo "Starting backup from \"$mailPath\" to \"$mailSnap$TIME\""

if [ "$mailSnap/$last" == "$mailSnap" ]; then
        echo "No previous backups found. Going to perform full backup."
        full=true
else
        echo "Using \"$mailSnap/$last\" as a source for the last backup."
        full=false
fi

# Make sure the base directory doesnt exist, and create it.
if [ -e "$mailSnap/$TIME" ]; then
        echo "ERROR: Folder already exist in \"$mailSnap/$TIME\". Backup is aborted!"
        exit 1
fi
mkdir "$mailSnap/$TIME"

# Perform the backup, using hardlinks if possible. 
if [ $full == true ] ; then
        echo "Starting to backup $mailPath"
        rsync -arv $mailPath/ $mailSnap/$TIME/
        echo "Finished to backup $mailSnap"
else
        echo "Starting to backup $mailSnap/$TIME/"
        rsync -arv --link-dest=$mailSnap/$last $mailPath $mailSnap/$TIME/
        echo "Finished to backup $mailSnap/$TIME/"
fi
