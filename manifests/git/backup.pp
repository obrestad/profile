# This class sets up backup of the git repositories.
class profile::git::backup {
  $usr = hiera('profile::backup::user')
  $hst = hiera('profile::backup::host')
  $base_path = hiera('profile::backup::base_path')

  $pth = "${base_path}/git/${::fqdn}"
  $folders = '/srv/git'

  cron { 'git-backup':
    command => "/usr/local/sbin/remote-backup ${usr} ${hst} ${pth} ${folders}",
    user    => root,
    hour    => [3, 9, 15, 21],
    minute  => [20],
    require => File['/usr/local/sbin/remote-backup'],
  }

  @@cron{ "clean-git-backup-${::fqdn}":
    command => "/usr/local/sbin/clean-backup ${pth} --silent --delete",
    user    => root,
    hour    => [4],
    minute  => [17],
    require => File['/usr/local/sbin/clean-backup'],
    tag     => 'clean-backups',
  }

  file { '/usr/local/sbin/git-backup':
    ensure => absent,
  }
}
