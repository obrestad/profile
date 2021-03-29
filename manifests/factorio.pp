# Configures misc. for a factorio server
class profile::factorio {
  $ports = lookup('profile::factorio::ports', {
    'value_type'    => Array[Integer],
    'default_value' => [ 34197 ],
  })

  firewall { '50 Accept factorio':
    proto  => 'udp',
    dport  => $ports,
    action => 'accept',
  }
}
