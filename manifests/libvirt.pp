# Installs and configures libvirt
class profile::libvirt {
  include ::profile::libvirt::networks
  include ::profile::libvirt::storage

  class { '::libvirt':
    mdns_adv => false,
  }
}
