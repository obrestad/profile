# Installs a samba-server and sets up users and shares.
class profile::samba {
  $samba_users = hiera_hash('profile::user::samba')
  $shares = hiera_hash('profile::samba::shares')

  class {'samba::server':
    workgroup     => 'rothaugane',
    server_string => 'Antoccino',
    interfaces    => 'eth0 lo',
    security      => 'user'
  }

  $samba_users.each | $username, $password | {
    samba::server::user { $username:
      password => $password,
    }
  }

  $shares.each | $sharename, $data | {
    samba::server::share { $sharename :
      comment       => $data['comment'],
      path          => $data['path'],
      guest_only    => false,
      guest_ok      => $data['guest_ok'],
      guest_account => 'nobody',
      browsable     => $data['browsable'],
      force_group   => 'users',
      read_only     => $data['read_only'],
    }
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
