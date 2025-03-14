# Install a local bind resolver
class profile::bind {
  include bind
  bind::server::conf { '/etc/bind/named.conf':
  }
}
