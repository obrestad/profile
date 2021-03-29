# Configures misc. for a factorio server
class profile::factorio {
  include ::profile::users::groups

  $ports = lookup('profile::factorio::ports', {
    'value_type'    => Array[Integer],
    'default_value' => [ 34197 ],
  })

  firewall { '50 Accept factorio':
    proto  => 'udp',
    dport  => $ports,
    action => 'accept',
  }

  user { 'factorio':
    ensure         => present,
    gid            => 'service',
    home           => '/opt/factorio',
    managehome     => true,
    password       => '*',
    purge_ssh_keys => true,
    shell          => '/bin/bash',
    uid            => '740',
  }
}
