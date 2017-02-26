class profile::firewall::minecraft {
  firewall { '010 accept incoming minecraft':
    proto    => 'tcp',
    dport    => 25565,
    action   => 'accept',
  }

  firewall { '010 v6 accept incoming minecraft':
    proto    => 'tcp',
    dport    => 25565,
    action   => 'accept',
    provider => 'ip6tables',
  }
}
