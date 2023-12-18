# Configures the hosts base networking
class profile::baseconfig::networking {
  $dns = lookup('profile::dns::resolvers', {
    'default_value' => [],
    'value_type'    => Array[Stdlib::IP::Address::Nosubnet],
  })
  $networks = lookup('profile::networks::interfaces', {
    'default_value' => {},
    'value_type'    => Hash,
  })

  $networks.each | $netname, $data | {
    if($data['method'] == 'shiftleader') {
      if($data['ipv4'] and $data['ipv4']['gateway']) {
        $v4route = [{
          'to' => '0.0.0.0/0',
          'via' => $data['ipv4']['gateway'],
        }]
      } else {
        $v4route = []
      }

      if($data['ipv6'] and $data['ipv6']['gateway']) {
        $v6route = [{
          'to' => '::/0',
          'via' => $data['ipv6']['gateway'],
        }]
      } else {
        $v6route = []
      }

      $netplandata = {
        'accept_ra'   => false,
        'dhcp'        => false,
        'addresses'   => [
          $::sl2['server']['interfaces'][$netname]['ipv4_cidr'],
          $::sl2['server']['interfaces'][$netname]['ipv6_cidr'],
        ] - [ undef, false ],
        'nameservers' => $dns,
        'routes'      => $v4route + $v6route,
      }
    } elsif ($data['method'] == 'auto') {
      $netplandata = {
        'accept_ra' => true,
        'dhcp'      => true,
      }
    } else {
      fail("Method ${data['method']} not known for interface ${netname}")
    }

    ::netplan::ethernets { $netname:
      dhcp6     => false,
      emit_lldp => true,
      *         => $netplandata,
    }
  }

  class { '::netplan':
    ethernets => length($networks) ? { 0 => undef, default => {} },
  }
}
