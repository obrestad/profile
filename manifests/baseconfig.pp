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
    servers   => [ 'ntp.hig.no'],
    restrict  => [
      'default kod nomodify notrap nopeer noquery',
      '-6 default kod nomodify notrap nopeer noquery',
    ],
  }
}
