# This class installs some basic software for all hosts.
class profile::baseconfig::software {
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
}
