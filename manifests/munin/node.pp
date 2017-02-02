# Installs the munin node
class profile::munin::node {
  class{ '::munin::node':
    allow => [ '2a01:79d:469c:429c::/64' ]
  }
}
