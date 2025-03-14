# Install a local bind resolver
class profile::bind {
  include bind
  bind::server::conf { '/etc/bind/named.conf':
  }

  file { '/etc/bind/db.root':
    ensure => link, 
    target => '/usr/share/dns/root.hints',
  }
}
