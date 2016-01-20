class profile::sudo {
  class { '::sudo': }

  sudo::conf { 'admins':
    priority => 10,
    content  => "%admins   ALL=(ALL:ALL) ALL",
  }
}
