#!/bin/bash
set -e

HOST=$1
CONTAINERNAME=$2
USERNAME=$3
PASSWORD=$4

store="/srv/backup/docker"
TIME=$(date +%y%m%d-%H%M%S)
filename="${TIME}.$CONTAINERNAME.sql.gz"

# Determine container-ID
container=$(ssh $HOST 'docker container list' | grep $CONTAINERNAME | \
					awk '{print $1}')

# Perform the backup of the mysql database
backupcmd="/usr/bin/mysqldump -u $USERNAME -p$PASSWORD django 2> /dev/null"
ssh $HOST "docker exec $container ${backupcmd} | gzip > ${CONTAINERNAME}.sql.gz"

# Create backup target-directory if it doesnt exist
if [ ! -e ${store}/${CONTAINERNAME} ]; then
  mkdir -p ${store}/${CONTAINERNAME}
fi

# Copy out the backup, and delete the remote file.
scp $HOST:${CONTAINERNAME}.sql.gz "${store}/${CONTAINERNAME}/${filename}"
ssh $HOST "rm ${CONTAINERNAME}.sql.gz"
