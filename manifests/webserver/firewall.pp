# Configures the firewall to pass http(s)
class profile::webserver::firewall {
  firewall { '010 accept incoming HTTP(S)':
    proto  => 'tcp',
    dport  => [80, 443],
    jump   => 'accept',
  }

  firewall { '010 v6 accept incoming HTTP(S)':
    proto    => 'tcp',
    dport    => [80, 443],
    jump     => 'accept',
    protocol => 'ip6tables',
  }
}
