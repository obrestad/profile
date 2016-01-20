#!/bin/bash

# Configuration
hostname=$(hostname)

backupUser="eigil"
backupHost="ristretto.rothaugane.com"
backupPath="/srv/backup/puppet/$hostname"

# Create root backupfolder if it doesnt exist
ssh $backupUser@$backupHost [ -e $backupPath ] 2> /dev/null
if [ $? == 1 ]; then
        ssh $backupUser@$backupHost mkdir $backupPath 2> /dev/null
fi

# Syncronize /etc as a configuration backup
rsync -a --delete /etc $backupUser@$backupHost:$backupPath/ 2> /dev/null > /dev/null

# Synchronize user homes
ssh $backupUser@$backupHost [ -e $backupPath/homes ] 2> /dev/null
if [ $? == 1 ]; then
        ssh $backupUser@$backupHost mkdir $backupPath/homes 2> /dev/null
fi

rsync -a --delete /root $backupUser@$backupHost:$backupPath/homes/ 2> /dev/null > /dev/null
rsync -a --delete /home/* $backupUser@$backupHost:$backupPath/homes/ 2> /dev/null > /dev/null
