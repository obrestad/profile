# Configures backup of /etc and home-folders
class profile::backup::general {
  $usr = lookup('profile::backup::user', String)
  $base_path = lookup('profile::backup::base_path', String)

  $pth = "${base_path}/homes/${::fqdn}"
  $folders = '/root /home /etc'

  @@cron { "general-backup-${::fqdn}":
    command => "/usr/local/sbin/backup-folders ${usr} ${::fqdn} ${pth} ${folders}",
    user    => $usr,
    hour    => [3, 9, 15, 21],
    minute  => [10],
    tag     => 'backup-pulls',
  }

  @@cron{ "clean-general-backup-${::fqdn}":
    command => "/usr/local/sbin/clean-backup ${pth} --silent --delete",
    user    => $usr,
    hour    => [4],
    minute  => [37],
    tag     => 'clean-backups',
  }
}
