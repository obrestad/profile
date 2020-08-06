# Installs and configures a puppet-server and sets up r10k
class profile::puppet::server {
  include ::profile::puppet::db
  include ::profile::puppet::server::firewall

  $r10krepo = lookup('profile::puppet::r10k::repo', Stdlib::HTTPUrl)

  class { 'r10k':
    remote => $r10krepo,
  }

  package { 'puppetserver':
    ensure => 'present',
  }

  service { 'puppetserver':
    ensure  => 'running',
    enable  => true,
    require => Package['puppetserver'],
  }
}
