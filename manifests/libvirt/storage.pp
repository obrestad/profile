# Configures libvirt storage 
class profile::libvirt::storage {
  $storage = lookup('profile::libvirt::storage', {
    'default_value' => {},
    'value_type'    => Hash,
  })

  $storage.each | $poolname, $data | {
    if(! $data['target']) {
      fail('A storage-pool needs a target!')
    }

    libvirt_pool { $poolname:
      ensure    => present,
      type      => pick($data['type'], 'logical'),
      autostart => pick($data['autostart'], true),
      target    => $data['target'],
    }
  }

  # Remove the default pools
  libvirt_pool { [ 'default', 'images' ]:
    ensure => absent,
  }
}
