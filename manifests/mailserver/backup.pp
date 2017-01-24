# Configuring backup of user mailboxes.
class profile::mailserver::backup {
  $usr = hiera('profile::backup::user')
  $hst = hiera('profile::backup::host')
  $base_path = hiera('profile::backup::base_path')

  $pth = "${base_path}/mail/${::fqdn}"
  $folders = '/srv/mail'

  cron { 'mail-backup':
    command => "/usr/local/sbin/remote-backup ${usr} ${hst} ${pth} ${folders}",
    user    => root,
    hour    => [3, 9, 15, 21],
    minute  => [10],
    require => File['/usr/local/sbin/remote-backup'],
  }

  cron { 'mail-remote-backup':
    ensure => absent,
  }
  file { '/usr/local/sbin/mail-remote-backup':
    ensure => absent,
  }
  file { '/usr/local/sbin/mail-backup':
    ensure => absent,
  }
}
