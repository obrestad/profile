# Installs and configures a minidlna-server
class profile::dlna::firewall {
  firewall { '50 Allow DLNA TCP - v4':
    proto  => 'tcp',
    dport  => 8200,
    action => 'accept',
  }
  firewall { '50 Allow DLNA UDP - v4':
    proto  => 'udp',
    dport  => [56627, 1900],
    action => 'accept',
  }
  firewall { '50 Allow DLNA TCP - v6':
    proto    => 'tcp',
    dport    => 8200,
    action   => 'accept',
    provider => 'ip6tables',
  }
  firewall { '50 Allow DLNA UDP - v6':
    proto    => 'udp',
    dport    => [56627, 1900],
    action   => 'accept',
    provider => 'ip6tables',
  }
}
