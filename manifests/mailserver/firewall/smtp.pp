# Configures firewall for SMTP 
class profile::mailserver::firewall::smtp {
  firewall { '010 accept incoming SMTP':
    proto  => 'tcp',
    dport  => [25, 587],
    jump   => 'accept',
  }
  firewall { '010 v6 accept incoming SMTP':
    proto    => 'tcp',
    dport    => [25, 587],
    jump     => 'accept',
    protocol => 'ip6tables',
  }
}
