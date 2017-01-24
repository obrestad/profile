#! /bin/bash

# Function which creates a folder on a remote host, if this folder did not
# already exist.
#
# $1 => "Username on remote host"
# $2 => "Hostname of the remote host"
# $3 => "Full path to folder"
#
ensureFolder () {
  ssh $1@$2 [ -e $3 ] 2> /dev/null
  if [ $? -eq 1 ]; then
    logger "Remote directory is missing. Creating $3"
    ssh $1@$2 mkdir -p $3 2> /dev/null >> /dev/null
  fi
}

# Function which tries to ping a remote host. If it is unsuccessful exit, a
# message is logged and the process exits.
#
# $1 = hostname/ipv6 address
#
testHost() {
  ping6 -w 1 -c 1 $1 &> /dev/null
  if [ $? != "0" ]; then
    logger "Cannot ping remote host($1). Aborting"
    exit 1
  fi 
}
