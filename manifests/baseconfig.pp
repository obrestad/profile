# Base-configuration of the hosts.
class profile::baseconfig {
  include ::profile::baseconfig::ntp
  include ::profile::baseconfig::ssh
  include ::profile::baseconfig::software
  include ::profile::baseconfig::sudo
  include ::profile::baseconfig::upgrades
}
