class profile::mailserver::backup {
  file { '/usr/local/sbin/mail-backup':
    owner  => 'root',
    group  => 'root',
    mode   => '0744',
    source => 'puppet:///modules/profile/scripts/mail-backup.sh',
  }->
  cron { 'mail-backup':
    command => '/usr/local/sbin/mail-backup',
    user    => root,
    hour    => [3, 9, 15, 21],
    minute  => [30],
  }
  file { '/usr/local/sbin/mail-remote-backup':
    owner  => 'root',
    group  => 'root',
    mode   => '0744',
    source => 'puppet:///modules/profile/scripts/mail-remote-backup.sh',
  }->
  cron { 'mail-backup':
    command => '/usr/local/sbin/mail-remote-backup',
    user    => root,
    hour    => [3, 9, 15, 21],
    minute  => [37],
  }
}
