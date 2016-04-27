class profile::java {
  class { 'java':
  }

  firewall { '015 accept incoming Minecraft':
    proto  => 'tcp',
    dport  => 25565,
    action => 'accept',
  }
}
