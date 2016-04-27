class profile::java {
  class { 'java':
    distribution => 'sun-jdk',
  }

  firewall { '015 accept incoming Minecraft':
    proto  => 'tcp',
    dport  => 25565,
    action => 'accept',
  }
}
