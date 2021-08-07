# Configuring backup of user mailboxes.
class profile::mailserver::backup {
  $usr = lookup('profile::backup::user', String)
  $base_path = lookup('profile::backup::base_path', String)

  $pth = "${base_path}/mailboxes/${::fqdn}"
  $folders = '/srv/mail'

  sudo::conf { 'mailbackup':
    priority => 15,
    content  => "backups ALL=(vmail) NOPASSWD:/usr/bin/rsync",
  }

  @@cron { "mailbox-backup-${::fqdn}":
    command => "/usr/local/sbin/backup-folders-sudo ${usr} ${::fqdn} ${pth} vmail ${folders}",
    user    => $usr,
    hour    => [3, 9, 15, 21],
    minute  => [10],
    tag     => 'backup-pulls',
  }

  @@cron{ "clean-mailserver-backup-${::fqdn}":
    command => "/usr/local/sbin/clean-backup ${pth} --silent --delete",
    user    => $usr,
    hour    => [4],
    minute  => [37],
    tag     => 'clean-backups',
  }
}
