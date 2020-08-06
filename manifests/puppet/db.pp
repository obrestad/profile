# Installs a simple puppetdb server, and configures the local puppet-server to
# use it.
class profile::puppet::db {
  # Configure puppetdb and its underlying database
  class { 'puppetdb': }

  # Configure the Puppet master to use puppetdb
  class { 'puppetdb::master::config': }
}
