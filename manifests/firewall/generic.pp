# Punch a generic hole in the firewall 
define profile::firewall::generic (
  Variant[Integer, Array[Integer], String] $port,
  String                                   $protocol,
) {
  require ::profile::firewall

  firewall { "5 Accept global v4 access to service ${name}":
    proto  => $protocol,
    dport  => $port,
    action => 'accept',
  }

  firewall { "5 Accept global v6 access to service ${name}":
    proto    => $protocol,
    dport    => $port,
    action   => 'accept',
    provider => 'ip6tables',
  }
}
