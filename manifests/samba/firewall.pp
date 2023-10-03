# Configures the firewall to allow my internal networks to reach the sambaserver 
class profile::samba::firewall {
  include ::profile::firewall

  $interface = lookup('profile::samba::interface', {
    'value_type' => String,
  })

  $v4nets = lookup('profile::samba::networks::ipv4', {
    'value_type'    => Array[Stdlib::IP::Address::V4::CIDR],
    'default_value' => [],
  })

  $v6nets = lookup('profile::samba::networks::ipv6', {
    'value_type'    => Array[Stdlib::IP::Address::V6::CIDR],
    'default_value' => [],
  })

  $v4nets.each | $net | {
    firewall { "50 accept SAMBA TCP from ${net}":
      jump    => 'accept',
      dport   => [139, 445],
      iniface => $interface,
      proto   => 'tcp',
      source  => $net,
    }
    firewall { "50 accept SAMBA UDP from ${net}":
      jump    => 'accept',
      dport   => [137, 138],
      iniface => $interface,
      proto   => 'udp',
      source  => $net,
    }
  }

  $v6nets.each | $net | {
    firewall { "50 accept SAMBA TCP from ${net}":
      jump     => 'accept',
      dport    => [139, 445],
      iniface  => $interface,
      proto    => 'tcp',
      protocol => 'ip6tables',
      source   => $net,
    }
    firewall { "50 accept SAMBA UDP from ${net}":
      jump     => 'accept',
      dport    => [137, 138],
      iniface  => $interface,
      proto    => 'udp',
      protocol => 'ip6tables',
      source   => $net,
    }
  }
}
