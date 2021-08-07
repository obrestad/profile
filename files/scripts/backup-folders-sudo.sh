#!/bin/bash

. /var/lib/backup-lib.sh

logger "Starting a remote-backup"

if [[ $# -lt 4 ]]; then
  logger "Cannot perform remote-backup. Too few arguments."
  echo "Usage: $0 <remote-user> <remote-host> <backup-path> <remote-file-owner> <remote-paths>"
  exit 1
fi

# Arguments
remoteUser=$1
remoteHost=$2
localPath=$3
fileOwner=$4

shift;shift;shift;shift;

paths=$@

date=$(date +%y%m%d-%H%M%S)

logger "Backing up the folders \"$paths\" from ${remoteUser}@${remoteHost}"

logger "Verifying that the remote host is reachable...."
testHost $remoteHost

logger "Verifying that the remote folders needed are present"
if [[ ! -e ${localPath} ]]; then
  mkdir "${localPath}"
fi
if [[ ! -e ${localPath}/snapshots ]]; then
  mkdir "${localPath}/snapshots"
fi
if [[ ! -e ${localPath}/logfiles ]]; then
  mkdir "${localPath}/logfiles"
fi

remoteUH="${remoteUser}@${remoteHost}"
lastBackup=$(ls -1 "${localPath}/snapshots" 2> /dev/null | tail -1)
backupPath="${localPath}/snapshots/${date}/"
output="${localPath}/logfiles/autobackup.${date}.log"
remote="${remoteUser}@${remoteHost}"

# if no previous backup is found, perform a full backup
if [[ -z $lastBackup ]]; then
  echo "No previous backups were found. Performing a full backup." >> $output
  logger "No previous backups were found. Performing a full backup."
  for path in $paths; do
    echo "Backing up $path" >> $output
    logger "Backing up $path"
    rsync -a -v "--rsync-path=sudo -u ${fileOwner} rsync" "${remote}:${path}" $backupPath 2> /dev/null >> $output
  done
else
  echo "Performing an incremental backup" >> $output
  logger "Performing an incremental backup"
  link="../$lastBackup/"
  for path in $paths; do
    echo "Backing up $path" >> $output
    logger "Backing up $path"
    rsync -a -v "--rsync-path=sudo -u ${fileOwner} rsync" "${remote}:${path}" $backupPath --link-dest=$link 2> /dev/null >> $output
  done
fi

logger "Backup of \"$paths\" to $remoteHost is finished"
