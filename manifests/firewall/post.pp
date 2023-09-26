class profile::firewall::post {
  firewall { '999 drop all':
    proto  => 'all',
    jump   => 'drop',
    before => undef,
  }

  firewall { '999 v6 drop all':
    proto    => 'all',
    jump     => 'drop',
    before   => undef,
    protocol => 'ip6tables',
  }
}
