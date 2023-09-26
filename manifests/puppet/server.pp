# Installs and configures a puppet-server and sets up r10k
class profile::puppet::server {
  include ::profile::puppet::altnames
  include ::profile::puppet::server::config
  include ::profile::puppet::server::firewall
  include ::profile::puppet::server::hiera
  include ::profile::puppet::server::install
  include ::profile::puppet::server::service
}
