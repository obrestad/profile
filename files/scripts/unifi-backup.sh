#!/bin/bash

# Configuration
hostname=$(hostname)

backupUser="remote-backup"
backupHost="antoccino.rothaugane.com"
backupPath="/srv/backup/puppet/$hostname"

# Create root backupfolder if it doesnt exist
ssh $backupUser@$backupHost [ -e $backupPath ] 2> /dev/null
if [ $? == 1 ]; then
  ssh $backupUser@$backupHost mkdir $backupPath 2> /dev/null
fi

# Synchronize git repositories
ssh $backupUser@$backupHost [ -e $backupPath/unifi ] 2> /dev/null
if [ $? == 1 ]; then
  ssh $backupUser@$backupHost mkdir $backupPath/unifi 2> /dev/null
fi

rsync -a --delete /var/lib/unifi/ $backupUser@$backupHost:$backupPath/unifi/ 2> /dev/null > /dev/null