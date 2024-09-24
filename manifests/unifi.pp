# Configures the firewall for the unifi controller 
class profile::unifi {
  $prefixes = lookup('profile::unifi::sources', {
    'default_value' => [],
    'value_type'    => Array[Stdlib::IP::Address],
  })

  profile::firewall::permit { 'Unifi UAP':
    prefixes => $prefixes,
    protocol => 'tcp',
    port     => [ 8080 ],
  }
  
  profile::firewall::permit { 'Unifi STUN':
    prefixes => $prefixes,
    protocol => 'udp',
    port     => [ 3478 ],
  }
}
