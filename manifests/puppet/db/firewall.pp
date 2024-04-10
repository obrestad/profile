# Configures the firewall to allow access to the puppetdbserver
class profile::puppet::db::firewall {
  $puppetserverprefixes = lookup('profile::puppet::server::prefixes', {
    'default_value' => [],
    'value_type'    => Array[Stdlib::IP::Address],
  })

  ::profile::firewall::permit { 'puppetdb':
    port     => 8081,
    prefixes => $puppetserverprefixes,
  }
}
