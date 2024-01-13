# Permits a certain port through the firewall for certain prefixes. 
define profile::firewall::permit (
  Stdlib::Port                $port,
  Array[Stdlib::IP::Address]  $prefixes,
  Enum['tcp', 'udp']          $proto = 'tcp',
) {
  $prefixes.each | $prefix | {
    if($prefix =~ Stdlib::IP::Address::V4::CIDR) {
      $protocol = 'IPv4'
    } elsif($prefix =~ Stdlib::IP::Address::V6::CIDR) {
      $protocol = 'IPv6'
    } else {
      fail("${prefix} is not an v4 or v6 CIDR")
    }

    firewall { "100 accept incoming ${name} from ${prefix}":
      proto    => $proto,
      dport    => $port,
      jump     => 'accept',
      protocol => $protocol,
      source   => $prefix,
    }
  }
}
