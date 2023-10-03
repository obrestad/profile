define setMuninIf {
  munin::plugin { "if_${name}":
    ensure => link,
    target => 'if_',
    config => ['user root'],
  }
  munin::plugin { "if_err_${name}":
    ensure => link,
    target => 'if_err_',
    config => ['user nobody'],
  }
}

# Installs the munin node
class profile::munin::node {
  $munin_master_v4 = hiera('profile::munin::master::v4')
  $munin_master_v6 = hiera('profile::munin::master::v6')

  $interfacesToConfigure = hiera('profile::interfaces', false)
  if($interfacesToConfigure) {
    setMuninIf { $interfacesToConfigure: }
  }

  package { 'libcache-cache-perl':
    ensure => present,
  }

  class{ '::munin::node':
    allow         => [ '^127\.0\.0\.1$', $munin_master_v4, $munin_master_v6 ],
    purge_configs => true,
  }

  firewall { '015 accept incoming munin monitoring':
    proto  => 'tcp',
    dport  => [4949],
    jump   => 'accept',
  }
  firewall { '015 v6 accept incoming munin monitoring':
    proto    => 'tcp',
    dport    => [4949],
    jump     => 'accept',
    protocol => 'ip6tables',
  }

  munin::plugin { 'apt':
    ensure => link,
    config => ['user root'],
  }
  munin::plugin { 'cpu':
    ensure => link,
  }
  munin::plugin { 'df':
    ensure       => link,
    config       => ['env.warning 85', 'env.critical 95'],
    config_label => 'df*',
  }
  munin::plugin { 'df_inode':
    ensure => link,
  }
  munin::plugin { 'diskstats':
    ensure => link,
  }
  munin::plugin { 'entropy':
    ensure => link,
  }
  munin::plugin { 'forks':
    ensure => link,
  }
  munin::plugin { 'fw_conntrack':
    ensure => link,
  }
  munin::plugin { 'fw_forwarded_local':
    ensure => link,
  }
  munin::plugin { 'fw_packets':
    ensure => link,
  }
  munin::plugin { 'interrupts':
    ensure => link,
  }
  munin::plugin { 'irqstats':
    ensure => link,
  }
  munin::plugin { 'load':
    ensure => link,
  }
  munin::plugin { 'memory':
    ensure => link,
  }
  munin::plugin { 'netstat':
    ensure => link,
  }
  munin::plugin { 'open_files':
    ensure => link,
  }
  munin::plugin { 'open_inodes':
    ensure => link,
  }
  munin::plugin { 'processes':
    ensure => link,
  }
  munin::plugin { 'proc_pri':
    ensure => link,
  }
  munin::plugin { 'swap':
    ensure => link,
  }
  munin::plugin { 'threads':
    ensure => link,
  }
  munin::plugin { 'uptime':
    ensure => link,
  }
  munin::plugin { 'users':
    ensure => link,
  }
}

