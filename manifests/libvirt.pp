# Installs and configures libvirt
class profile::libvirt {
  $networks = lookup('profile::libvirt::networks', {
    'default_value' => {},
    'value_type'    => Hash,
  })

  class { '::libvirt':
    mdns_adv => false,
  }

  $networks.each | $netname, $data | {
    ::libvirt::network { $netname:
      ensure             => 'running',
      autostart          => true,
      forward_mode       => 'bridge',
      forward_interfaces => [ $data['interfaces'] ],
    }
  }
}
