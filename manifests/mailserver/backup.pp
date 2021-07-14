# Configuring backup of user mailboxes.
class profile::mailserver::backup {
  $usr = lookup('profile::backup::user', String)
  $base_path = lookup('profile::backup::base_path', String)

  $pth = "${base_path}/mailboxes/${::fqdn}"
  $folders = '/srv/mail'

  @@cron { "mailbox-backup-${::fqdn}":
    command => "/usr/local/sbin/remote-backup ${usr} ${hst} ${pth} ${folders}",
    user    => root,
    hour    => [3, 9, 15, 21],
    minute  => [10],
    tag     => 'backup-pulls',
  }

  @@cron{ "clean-mailserver-backup-${::fqdn}":
    command => "/usr/local/sbin/clean-backup ${pth} --silent --delete",
    user    => root,
    hour    => [4],
    minute  => [37],
    tag     => 'clean-backups',
  }
}
