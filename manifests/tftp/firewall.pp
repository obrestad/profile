# This class configures firewall rules for TFTP
class profile::tftp::firewall {
  # TFTP also uses higher-numbered ports for the actual data-transfer; but this
  # is handled by the defult allow ESTABLISHED incoming rule from baseconfig.
  firewall { '010 accept incoming TFTP-Requests':
    proto  => 'udp',
    dport  => 69,
    jump   => 'accept',
  }
}
