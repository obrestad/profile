#!/bin/bash

. /var/lib/backup-lib.sh

if [[ $# -lt 4 ]]; then
  echo "Usage: $0 <remote-user> <remote-host> <remote-path> <paths>"
  exit 1
fi

# Arguments
remoteUser=$1
remoteHost=$2
remotePath=$3

shift;shift;shift;

paths=$@

date=$(date +%y%m%d-%H%M%S)
output=/tmp/autobackup.$date.log

testHost $remoteHost

ensureFolder $remoteUser $remoteHost $remotePath
ensureFolder $remoteUser $remoteHost "${remotePath}/snapshots"
ensureFolder $remoteUser $remoteHost "${remotePath}/logfiles"

remoteUH="${remoteUser}@${remoteHost}"
lastBackup=$(ssh ${remoteUH} ls -1 $remotePath/snapshots 2> /dev/null | tail -1)
fullRPath="$remotePath/snapshots/$date/"
remote=${remoteUser}@${remoteHost}:$fullRPath

# if no previous backup is found, perform a full backup
if [[ -z $lastBackup ]]; then
  echo "No previous backups were found. Performing a full backup." >> $output
  logger "No previous backups were found. Performing a full backup."
  for path in $paths; do
    echo "Backing up $path" >> $output
    logger "Backing up $path"
    rsync -a -v $path $remote 2> /dev/null >> $output
  done
else
  echo "Performing an incremental backup" >> $output
  logger "Performing an incremental backup"
  link="../$lastBackup/"
  for path in $paths; do
    echo "Backing up $path" >> $output
    logger "Backing up $path"
    rsync -a -v $path $remote --link-dest=$link 2> /dev/null >> $output
  done
fi

if [[ $output != "/dev/fd/1" ]]; then
  scp $output \
    ${remoteUser}@${remoteHost}:$remotePath/logfiles/$date.log &> /dev/null
  rm $output
fi

logger "Backup of \"$paths\" to $remoteHost is finished"

exit 0
