# Installs the munin node
class profile::munin::node {
  class{ '::munin::node':
    allow => [ '127\.0\.0\.1' ]
  }
}
