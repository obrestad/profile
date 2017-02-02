# Installs the munin node
class profile::munin::node {
  class{ '::munin::node':
    allow => [ '::ffff:127.0.0.1/128', '2a01:79d:469c:429c::/64' ]
  }
}
