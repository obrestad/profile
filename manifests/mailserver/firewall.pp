class profile::mailserver::firewall {
  firewall { '010 accept incoming SMTP':
    proto  => 'tcp',
    dport  => [25, 465, 587],
    action => 'accept',
  }
  firewall { '010 accept incoming IMAP':
    proto  => 'tcp',
    dport  => [993],
    action => 'accept',
  }

  firewall { '010 v6 accept incoming SMTP':
    proto    => 'tcp',
    dport    => [25, 465, 587],
    action   => 'accept',
    provider => 'ip6tables',
  }
  firewall { '010 v6 accept incoming IMAP':
    proto    => 'tcp',
    dport    => [993],
    action   => 'accept',
    provider => 'ip6tables',
  }
}
