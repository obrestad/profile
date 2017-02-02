# Installs the munin master node
class profile::munin::master {
  class{ '::munin::master':
  }
}
