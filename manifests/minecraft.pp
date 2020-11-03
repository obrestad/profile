# Istalls JAVA and configures the firewall to allow a minecraft-server.
class profile::minecraft {
  $ports = lookup('profile::minecraft::ports', {
    'value_type'    => Array[Integer],
    'default_value' => [ 25565 ],
  })

  package { 'openjdk-8-jdk':
    ensure => 'present',
  }

  firewall { '50 Accept minecraft':
    proto  => 'tcp',
    dport  => $ports,
    action => 'accept',
  }
}
