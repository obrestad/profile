# This class configures the firewall to allow various git related services.
class profile::git::firewall {
  firewall { '013 accept incoming git':
    proto  => 'tcp',
    dport  => [9418],
    action => 'accept',
  }

  firewall { '013 v6 accept incoming git':
    proto    => 'tcp',
    dport    => [9418],
    action   => 'accept',
    provider => 'ip6tables',
  }
}
