# Installs the munin node
class profile::munin::node {
  $munin_master_v4 = hiera('profile::munin::master::v4')
  $munin_master_v6 = hiera('profile::munin::master::v4')

  class{ '::munin::node':
    allow => [ '^127\.0\.0\.1$', $munin_master_v4, $munin_master_v6 ]
  }

  firewall { '015 accept incoming munin monitoring':
    proto  => 'tcp',
    dport  => [4949],
    action => 'accept',
  }
  firewall { '015 v6 accept incoming munin monitoring':
    proto    => 'tcp',
    dport    => [4949],
    action   => 'accept',
    provider => 'ip6tables',
  }
}
