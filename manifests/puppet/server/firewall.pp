# Configures the firewall to allow access to the puppetserver
class profile::puppet::server::firewall {
  include ::profile::firewall

  firewall { '005 accept incoming puppetmaster':
    proto  => 'tcp',
    dport  => 8140,
    action => 'accept',
  }

  firewall { '005 v6 accept incoming puppetmaster':
    proto    => 'tcp',
    dport    => 8140,
    action   => 'accept',
    provider => 'ip6tables',
  }
}
