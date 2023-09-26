class profile::firewall::pre {
  Firewall {
    require => undef,
  }

  # Default firewall rules
  firewall { '000 accept all icmp':
    proto  => 'icmp',
    jump   => 'accept',
  }->
  firewall { '001 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    jump    => 'accept',
  }->
  firewall { '002 reject local traffic not on loopback interface':
    iniface     => '! lo',
    proto       => 'all',
    destination => '127.0.0.1/8',
    jump        => 'reject',
  }->
  firewall { '003 accept related established rules':
    proto  => 'all',
    state  => ['RELATED', 'ESTABLISHED'],
    jump   => 'accept',
  }->
  firewall { '004 accept incoming SSH':
    proto  => 'tcp',
    dport  => 22,
    jump   => 'accept',
  }

  # Default firewall IPv6 rules
  firewall { '000 v6 accept all icmp':
    proto    => 'ipv6-icmp',
    jump     => 'accept',
    provider => 'ip6tables',
  }->
  firewall { '001 v6 accept all to lo interface':
    proto    => 'all',
    iniface  => 'lo',
    jump     => 'accept',
    provider => 'ip6tables',
  }->
  firewall { '002 v6 allow link-local':
    proto    => 'all',
    source   => 'fe80::/10',
    jump     => 'accept',
    provider => 'ip6tables',
  }->
  firewall { '003 v6 accept related established rules':
    proto    => 'all',
    state    => ['RELATED', 'ESTABLISHED'],
    jump     => 'accept',
    provider => 'ip6tables',
  }->
  firewall { '004 v6 accept incoming SSH':
    proto    => 'tcp',
    dport    => 22,
    jump     => 'accept',
    provider => 'ip6tables',
  }
}
