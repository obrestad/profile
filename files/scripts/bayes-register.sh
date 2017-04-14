#!/bin/bash

#
# Small script working trough maildirs looking for the folders
# "spamassasin-(sp|h)am". Mails found in these folders are collected, and
# ran trough the bayes learning mechanism.
#

vhostdir="/srv/mail/vhosts"

if [[ ! -e /tmp/spamassasin-ham ]]; then
	echo Creating /tmp/spamassasin-ham
	mkdir /tmp/spamassasin-ham
fi
if [[ ! -e /tmp/spamassasin-spam ]]; then
	echo Creating /tmp/spamassasin-spam
	mkdir /tmp/spamassasin-spam
fi

domains=$(ls -1 $vhostdir)
for domain in $domains; do
	echo $domain
	mailboxes=$(ls -1 "$vhostdir/$domain")
	for mailbox in $mailboxes; do
		echo $domain - $mailbox
		if [[ -e "$vhostdir/$domain/$mailbox/.spamassassin-spam/" ]]; then
			echo Spamfolder exists
			echo "$vhostdir/$domain/$mailbox/.spamassassin-spam/"
			rsync -av --chown debian-spamd:debian-spamd \
					"$vhostdir/$domain/$mailbox/.spamassassin-spam/cur/" \
					/tmp/spamassasin-spam/
		fi
		if [[ -e "$vhostdir/$domain/$mailbox/.spamassassin-ham/" ]]; then
			echo "Hamfolder exists"
			echo "$vhostdir/$domain/$mailbox/.spamassassin-ham/"
			rsync -av --chown debian-spamd:debian-spamd \
					"$vhostdir/$domain/$mailbox/.spamassassin-ham/cur/" \
					/tmp/spamassasin-ham/
		fi
	done
done

echo "Learn SPAM"
sudo -u debian-spamd sa-learn --spam --showdots --dir /tmp/spamassasin-spam
echo "Learn HAM"
sudo -u debian-spamd sa-learn --ham --showdots --dir /tmp/spamassasin-ham
