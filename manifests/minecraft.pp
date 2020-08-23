# Istalls JAVA and configures the firewall to allow a minecraft-server.
class profile::minecraft {
  package { 'openjdk-8-jdk':
    ensure => 'present',
  }

  firewall { '50 Accept minecraft':
    proto  => 'tcp',
    dport  => 25565,
    action => 'accept',
  }
}
