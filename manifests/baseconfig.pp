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
    'python3-pil',
    'screen',
    'speedtest-cli',
    'sysstat',
    'vim'
  ] :
    ensure => 'latest',
  }

  class { '::ntp':
    servers  => [
      '0.pool.ntp.org',
      '1.pool.ntp.org',
      '2.pool.ntp.org',
      '3.pool.ntp.org',
    ],
    restrict => [
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
}
