# This class configures firewall rules for DHCP 
class profile::dhcp::firewall {
  firewall { '010 accept incoming DHCP-Requests':
    proto  => 'udp',
    dport  => [67, 68],
    jump   => 'accept',
  }
}

