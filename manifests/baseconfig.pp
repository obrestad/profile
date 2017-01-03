# Performs a basic configuration of the hosts. Sets up ntp, ssh, backup and
# installs some useful tools.
class profile::baseconfig {
  package { [
    'bc',
    'fio',
    'gdisk',
    'hdparm',
    'htop',
    'iperf3',
    'lsb-release',
    'nmap',
    'pwgen',
    'screen',
    'speedtest-cli',
    'sysstat',
    'vim'
  ] :
    ensure => 'latest',
  }

  class { '::ntp':
    servers   => [
      '0.pool.ntp.org',
      '1.pool.ntp.org',
      '2.pool.ntp.org',
      '3.pool.ntp.org'
    ],
    restrict  => [
      'default kod nomodify notrap nopeer noquery',
      '-6 default kod nomodify notrap nopeer noquery',
    ],
  }

  class { 'ssh':
    storeconfigs_enabled => true,
    server_options       => {
      'Port'                   => [22],
      'PasswordAuthentication' => 'yes',
      'X11Forwarding'          => 'no',
    },
  }

  file { '/usr/local/sbin/general-backup':
    owner  => 'root',
    group  => 'root',
    mode   => '0744',
    source => 'puppet:///modules/profile/scripts/general-backup.sh',
  }->
  cron { 'general-backup':
    command => '/usr/local/sbin/general-backup',
    user    => root,
    hour    => [3, 9, 15, 21],
    minute  => [0],
  }
}
