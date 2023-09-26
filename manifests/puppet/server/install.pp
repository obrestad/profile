# Installs the puppetmaster with r10k.
class profile::puppet::server::install {
  include ::profile::puppet::server::r10k

  package { 'puppetserver':
    ensure => 'present',
  }
}
