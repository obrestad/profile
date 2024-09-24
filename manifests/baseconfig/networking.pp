# Configures the hosts base networking
class profile::baseconfig::networking {
  $dns = lookup('profile::dns::resolvers', {
    'default_value' => [],
    'value_type'    => Array[Stdlib::IP::Address::Nosubnet],
  })
  $dns_search = lookup('profile::dhcp::searchdomains', {
    'default_value' => [],
    'value_type'    => Array[String],
  })

  $networks = lookup('profile::network::interfaces', {
    'default_value' => {},
    'value_type'    => Hash,
  })

  $vlans = lookup('profile::network::vlans', {
    'default_value' => {},
    'value_type'    => Hash,
  })

  $networks.each | $netname, $data | {
    $ipv4 = ('ipv4' in $data) ? { true => $data['ipv4']['addresses'], false => []}
    $ipv6 = ('ipv6' in $data) ? { true => $data['ipv6']['addresses'], false => []}

    ::profile::baseconfig::networking::interface { $netname:
      addresses         => $ipv4 + $ipv6 - [ undef ],
      method            => $data['method'],
      dns_resolvers     => $dns,
      dns_searchdomains => $dns_search,
      gateway_v4        => ('ipv4' in $data) ? {
        true => $data['ipv4']['gateway'], false => undef },
      gateway_v6        => ('ipv6' in $data) ? {
        true => $data['ipv6']['gateway'], false => undef },
      tableid           => $data['tableid'],
    }
  }

  $vlans.each | $netname, $data | {
    $ipv4 = ('ipv4' in $data) ? { true => $data['ipv4']['addresses'], false => []}
    $ipv6 = ('ipv6' in $data) ? { true => $data['ipv6']['addresses'], false => []}

    ::profile::baseconfig::networking::interface { $netname:
      addresses         => $ipv4 + $ipv6 - [ undef ],
      method            => $data['method'],
      dns_resolvers     => $dns,
      dns_searchdomains => $dns_search,
      gateway_v4        => ('ipv4' in $data) ? {
        true => $data['ipv4']['gateway'], false => undef },
      gateway_v6        => ('ipv6' in $data) ? {
        true => $data['ipv6']['gateway'], false => undef },
      parent            => $data['parent'],
      tableid           => $data['tableid'],
      type              => 'vlan',
      vlan_id           => $data['vlanid'],
    }
  }

  class { '::netplan':
    ethernets => (length($networks) == 0) ? { true => undef, default => {} },
    vlans     => (length($vlans) == 0) ? { true => undef, default => {} },
  }
}
