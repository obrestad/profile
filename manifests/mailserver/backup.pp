class profile::mailserver::backup {
  file { '/usr/local/sbin/mail-backup':
    owner  => 'root',
    group  => 'root',
    mode   => '0744',
    source => 'puppet:///modules/profile/scripts/mail-backup.sh',
  #}->
  #cron { 'general-backup':
  #  command => '/usr/local/sbin/general-backup',
  #  user    => root,
  #  hour    => [3, 9, 15, 21],
  #  minute  => [0],
  }
}
