# Installs and configures a minidlna-server
class profile::dlna::firewall {
  firewall { '50 Allow DLNA TCP - v4':
    proto  => 'tcp',
    dport  => 8200,
    jump   => 'accept',
  }
  firewall { '50 Allow DLNA UDP - v4':
    proto  => 'udp',
    dport  => [56627, 1900],
    jump   => 'accept',
  }
  firewall { '50 Allow DLNA TCP - v6':
    proto    => 'tcp',
    dport    => 8200,
    jump     => 'accept',
    protocol => 'ip6tables',
  }
  firewall { '50 Allow DLNA UDP - v6':
    proto    => 'udp',
    dport    => [56627, 1900],
    jump     => 'accept',
    protocol => 'ip6tables',
  }
}
