# Installs a ubnt controller
class profile::ubnt {
  apt::source { 'ubnt':
    location   => 'http://www.ubnt.com/downloads/unifi/debian',
    repos      => 'ubiquiti',
    release    => 'stable',
    key        => 'C0A52C50',
    key_server => 'keyserver.ubuntu.com',
  }

  package { 'unifi':
    ensure  => 'present',
    require => Apt::Source['ubnt'],
  }

  service { 'unifi':
    ensure  => 'running',
    require => Package['unifi'],
  }

  firewall { '011 accept incoming UAPs and management':
    proto   => 'tcp',
    dport   => [8080, 8443],
    iniface => 'eth0',
    action  => 'accept',
  }

  firewall { '011 v6 accept incoming UAPs and management':
    proto    => 'tcp',
    dport    => [8080, 8443],
    action   => 'accept',
    iniface  => 'eth0',
    provider => 'ip6tables',
  }
}
