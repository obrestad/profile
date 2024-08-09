# Configures the firewall to allow IMAPS 
class profile::mailserver::firewall::imap {
  firewall { '010 accept incoming IMAP':
    proto  => 'tcp',
    dport  => [993],
    jump   => 'accept',
  }
  firewall { '010 v6 accept incoming IMAP':
    proto    => 'tcp',
    dport    => [993],
    jump     => 'accept',
    provider => 'ip6tables',
  }
}
