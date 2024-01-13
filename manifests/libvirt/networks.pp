# Configures libvirt networking 
class profile::libvirt::networks {
  $networks = lookup('profile::libvirt::networks', {
    'default_value' => {},
    'value_type'    => Hash,
  })

  $networks.each | $netname, $data | {
    ::libvirt::network { $netname:
      ensure             => 'running',
      autostart          => true,
      forward_mode       => 'bridge',
      forward_interfaces => [ $data['interfaces'] ],
    }
  }
}
