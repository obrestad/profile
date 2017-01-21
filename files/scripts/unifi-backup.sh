#!/bin/bash

# Configuration
hostname=$(hostname)

remoteUser="remote-backup"
remoteHost="antoccino.rothaugane.com"
remotePath="/srv/backup/unifi/$hostname"

date=$(date +%y%m%d-%H%M%S)

if [[ $1 == "-v" ]]; then
  output="/dev/fd/1"
else
  output=/tmp/autobackup.unifi.$date.log
fi

# Function which creates a folder on a remote host, if this folder did not
# already exist.
#
# $1 => "Hostname of the remote host"
# $2 => "Full path to folder"
#
ensureFolder () {
  folder=$1
  ssh ${remoteUser}@$remoteHost [ -e $folder ] 2> /dev/null
  if [ $? -eq 1 ]; then
    echo "Remote directory is missing. Creating $folder" >> $output
    ssh ${remoteUser}@$remoteHost mkdir -p $folder 2> /dev/null >> $output
  fi
}

ensureFolder $remotePath
ensureFolder "${remotePath}/snapshots"
ensureFolder "${remotePath}/logfiles"

remoteUH="${remoteUser}@${remoteHost}"
lastBackup=$(ssh ${remoteUH} ls -1 $remotePath/snapshots 2> /dev/null | tail -1)
fullRPath="$remotePath/snapshots/$date/"
remote=${remoteUser}@${remoteHost}:$fullRPath

# if no previous backup is found, perform a full backup
if [[ -z $lastBackup ]]; then
  echo "No previous backups were found. Performing a full backup." >> $output
  rsync -a -v /var/lib/unifi/ $remote 2> /dev/null >> $output
else
  echo "Performing an incremental backup" >> $output
  link="../$lastBackup/"
  rsync -a -v /var/lib/unifi/ $remote --link-dest=$link 2> /dev/null >> $output
fi

if [[ $output != "/dev/fd/1" ]]; then
  scp $output \
    ${remoteUser}@${remoteHost}:$remotePath/logfiles/$date.log &> /dev/null
  rm $output
fi

exit 0
