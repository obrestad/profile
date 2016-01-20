class profile::sudo {
  class { '::sudo': }
  sudo::conf { 'sudo':
    priority => 10,
    content  => "%sudo   ALL=(ALL:ALL) ALL",
  }
}
