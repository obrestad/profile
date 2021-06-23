# Configures the firewall to pass http(s)
class profile::webserver::firewall {
  firewall { '010 accept incoming HTTP(S)':
    proto  => 'tcp',
    dport  => [80, 443],
    action => 'accept',
  }

  firewall { '010 v6 accept incoming HTTP(S)':
    proto    => 'tcp',
    dport    => [80, 443],
    action   => 'accept',
    provider => 'ip6tables',
  }
}
