class profile::baseconfig {
  package { [
    'bc',
    'fio',
    'git',
    'gdisk',
    'htop',
    'iperf3',
    'nmap',
    'pwgen',
    'screen',
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
    storeconfigs_enabled => false,
    server_options => {
      'Port' => [22],
      'PasswordAuthentication' => 'yes',
      'X11Forwarding' => 'no',
    },
  }
  
  file { "/usr/local/sbin/general-backup":
    owner => "root",
    group => "root",
    mode  => 744,
    source => "puppet:///modules/profile/scripts/general-backup.sh",
  }
}
