# Installs and configures a puppet-server and sets up r10k
class profile::puppet::server {
  include ::profile::puppet::server::firewall

  $r10krepo = lookup('profile::puppet::r10k::repo', Stdlib::HTTPUrl)

  # Install and configure r10k
  class { 'r10k':
    remote => $r10krepo,
  }

  # Configure puppetdb and its underlying database
  class { 'puppetdb': }

  # Install and configure the Puppet master to use puppetdb
  class { 'puppetdb::master::config': }
}
