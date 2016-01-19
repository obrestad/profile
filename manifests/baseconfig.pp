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
}
