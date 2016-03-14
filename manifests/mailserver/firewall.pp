class profile::mailserver::firewall {
  firewall { '010 accept incoming SMTP':
    proto  => 'tcp',
    dport  => [25, 587],
    action => 'accept',
  }
}
