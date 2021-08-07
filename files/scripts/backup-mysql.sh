#!/bin/bash
set -e

HOST=$1
USERNAME=$2
PASSWORD=$3
DATABASE=$4

store="/srv/backup/mysql"
TIME=$(date +%y%m%d-%H%M%S)
filename="${DATABASE}.${TIME}.sql.gz"

backupcmd="/usr/bin/mysqldump -u $USERNAME -p$PASSWORD $DATABASE 2> /dev/null"
ssh $HOST "${backupcmd} | gzip > ${filename}"

# Create backup target-directory if it doesnt exist
if [ ! -e ${store}/${HOST} ]; then
  mkdir -p ${store}/${HOST}
fi

# Copy out the backup, and delete the remote file.
scp $HOST:${filename} "${store}/${HOST}/${filename}"
ssh $HOST "rm ${filename}"
