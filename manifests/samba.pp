class profile::samba {
  $samba_eigil_pass = hiera('profile::user::eigil::samba::pass')

  class {'samba::server':
    workgroup     => 'rothaugane',
    server_string => 'Antoccino',
    interfaces    => 'eth0 lo',
    security      => 'user'
  }

  samba::server::user { 'eigil':
    password => $samba_eigil_pass,
  }

  samba::server::share {'archive':
    comment              => 'Archived stuff',
    path                 => '/srv/archive',
    guest_only           => false,
    guest_ok             => false,
    guest_account        => 'nobody',
    browsable            => true,
    force_group          => 'users',
  }

  firewall { '011 accept incoming SAMBA TCP':
    proto   => 'tcp',
    dport   => [139, 445],
    iniface => 'eth0',
    action  => 'accept',
  }
  firewall { '011 accept incoming SAMBA UDP':
    proto   => 'udp',
    dport   => [137, 138],
    iniface => 'eth0',
    action  => 'accept',
  }

  firewall { '011 v6 accept incoming SAMBA TCP':
    proto    => 'tcp',
    dport    => [139, 445],
    action   => 'accept',
    iniface  => 'eth0',
    provider => 'ip6tables',
  }
  firewall { '011 v6 accept incoming SAMBA UDP':
    proto    => 'udp',
    dport    => [137, 138],
    action   => 'accept',
    iniface  => 'eth0',
    provider => 'ip6tables',
  }
}
