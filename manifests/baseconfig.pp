# Base-configuration of the hosts.
class profile::baseconfig {
  $networking = lookup('profile::baseconfig::network::config', {
    'default_value' => true,
    'value_type'    => Boolean,
  })

  if($networking) {
    include ::profile::baseconfig::networking
  }

  include ::profile::backup::general

  include ::profile::baseconfig::disk
  include ::profile::baseconfig::ntp
  include ::profile::baseconfig::ssh
  include ::profile::baseconfig::software
  include ::profile::baseconfig::sudo
  include ::profile::baseconfig::upgrades

  include ::profile::firewall

  include ::profile::puppet::altnames

  include ::profile::users
}
