# Installs my backupscript, and configurs backup of configurations and home
# folders.
class profile::backup::general {
  $usr = hiera('profile::backup::user')
  $hst = hiera('profile::backup::host')
  $base_path = hiera('profile::backup::base_path')

  $pth = "${base_path}/general/${::fqdn}"
  $folders = '/root /home /etc'

  file { '/var/lib/backup-lib.sh':
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/profile/scripts/backup-lib.sh',
  }
  file { '/usr/local/sbin/remote-backup':
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///modules/profile/scripts/remote-backup.sh',
    require => File['/var/lib/backup-lib.sh'],
  }
  file { '/usr/local/sbin/clean-backup':
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/profile/scripts/clean-backup.py',
  }
  cron { 'general-backup':
    command => "/usr/local/sbin/remote-backup ${usr} ${hst} ${pth} ${folders}",
    user    => root,
    hour    => [3, 9, 15, 21],
    minute  => [0],
    require => File['/usr/local/sbin/remote-backup'],
  }

  @@cron{ "clean-general-backup${::fqdn}":
    command => "/usr/local/sbin/clean-backup ${pth} --silent --delete",
    user    => root,
    hour    => [4],
    minute  => [56],
    require => File['/usr/local/sbin/clean-backup'],
    tag     => 'clean-backups',
  }

  file { '/usr/local/sbin/general-backup':
    ensure => absent,
  }
}
