# Configures the firewall to allow mysql-clients 
class profile::mysql::firewall {
  $prefixes = lookup('profile::mysql::client::prefixes', {
    'default_value' => [],
    'value_type'    => Array[Stdlib::IP::Address],
  })

  $prefixes.each | $prefix | {
    if($prefix =~ Stdlib::IP::Address::V4::CIDR) {
      $protocol = 'IPv4'
    } elsif($prefix =~ Stdlib::IP::Address::V6::CIDR) {
      $protocol = 'IPv6'
    } else {
      fail("${prefix} is not an v4 or v6 CIDR")
    }
    firewall { '010 v6 accept incoming HTTP(S)':
      proto    => 'tcp',
      dport    => 3306,
      jump     => 'accept',
      protocol => $protocol,
      source   => $prefix,
    }
  }
}
