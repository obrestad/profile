# Installs and configures a minidlna-server
class profile::dlna::server {
  $ifname = lookup('profile::interface::main', String)

  include ::profile::dlna::config
  include ::profile::dlna::firewall

  package { 'minidlna':
    ensure => present,
  }

  service { 'minidlna':
    ensure => running,
  }

  Package['minidlna'] -> Class['::profile::dlna::config']
  Class['::profile::dlna::config'] ~> Service['minidlna']
}
