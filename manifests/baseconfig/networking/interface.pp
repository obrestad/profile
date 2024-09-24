# Configures an interface (physical or VLAN)  
define profile::baseconfig::networking::interface (
  Enum['shiftleader', 'auto', 'up', 'manual'] $method,
  Array[Stdlib::IP::Address::CIDR]            $addresses = [],
  Array[Stdlib::IP::Address::Nosubnet]        $dns_resolvers = [],
  Array[String]                               $dns_searchdomains = [],
  Optional[Stdlib::IP::Address::V4::Nosubnet] $gateway_v4 = undef,
  Optional[Stdlib::IP::Address::V6::Nosubnet] $gateway_v6 = undef,
  Optional[String]                            $parent = undef,
  Optional[Integer]                           $tableid = undef,
  Enum['physical', 'vlan']                    $type = 'physical',
  Optional[Integer]                           $vlan_id = undef,
) {
  if($method in ['shiftleader', 'manual']) {
    if($gateway_v4) {
      if($tableid) {
        $v4route = [{
          'to'    => '0.0.0.0/0',
          'via'   => $gateway_v4,
          'table' => $tableid,
        }, {
          'to'    => ip_network($::sl2['server']['interfaces'][$name]['ipv4_cidr']),
          'scope' => 'link',
          'table' => $tableid,
        }]
        $v4policy = [{
          'to'    => '0.0.0.0/0',
          'from'  => ip_network($::sl2['server']['interfaces'][$name]['ipv4_cidr']),
          'table' => $tableid,
        }]
      } else {
        $v4route = [{
          'to'  => '0.0.0.0/0',
          'via' => $gateway_v4,
        }]
        $v4policy = []
      }
    } else {
      $v4route = []
      $v4policy = []
    }

    if($gateway_v6) {
      if($tableid) {
        $v6route = [{
          'to'    => '::/0',
          'via'   => $gateway_v6,
          'table' => $tableid,
        }, {
          'to'    => ip_network($::sl2['server']['interfaces'][$name]['ipv6_cidr']),
          'scope' => 'link',
          'table' => $tableid,
        }]
        $v6policy = [{
          'to'    => '::/0',
          'from'  => ip_network($::sl2['server']['interfaces'][$name]['ipv6_cidr']),
          'table' => $tableid,
        }]
      } else {
        $v6route = [{
          'to'  => '::/0',
          'via' => $gateway_v6,
        }]
        $v6policy = []
      }
    } else {
      $v6route = []
      $v6policy = []
    }

    $addressdata = {
      'accept_ra'   => false,
      'dhcp4'       => false,
      'addresses'   => $addresses + [
        $::sl2['server']['interfaces'][$name]['ipv4_cidr'],
        $::sl2['server']['interfaces'][$name]['ipv6_cidr'],
      ] - [ undef, false ],
      'nameservers' => {
        'addresses' => $dns_resolvers,
        'search'    => $dns_searchdomains,
      },
      'routes'      => $v4route + $v6route,
    }
  } elsif ($method == 'auto') {
    $addressdata = {
      'accept_ra' => true,
      'dhcp4'     => true,
    }
  } elsif ($method == 'up') {
    $addressdata = {
      'accept_ra' => false,
      'dhcp4'     => false,
    }
  } else {
    fail("Method ${method} not known for interface ${name}")
  }

  if($type == 'physical') {
    ::netplan::ethernets { $name:
      dhcp6     => false,
      emit_lldp => true,
      *         => $addressdata,
    }
  } elsif($type == 'vlan') {
    if($parent == undef or $vlan_id == undef) {
      fail("The VLAN-interface ${name} needs a parent and VLAN ID")
    }

    ::netplan::vlans { $name:
      dhcp6 => false,
      id    => $vlan_id,
      link  => $parent,
      *     => $addressdata,
    }
  } else {
    fail("Type ${type} not known for interface ${name}")
  }
}
