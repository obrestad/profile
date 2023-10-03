class profile::java {
  class { 'java':
    distribution => 'oracle-jdk',
  }

#  java::oracle { 'jdk8' :
#    ensure  => 'present',
#    version => '8',
#    java_se => 'jdk',
#  }

  firewall { '015 accept incoming Minecraft':
    proto  => 'tcp',
    dport  => [25565, 25566],
    jump   => 'accept',
  }
}
