# Installs and configures a postgres server
class profile::postgres {
  $password = lookup('profile::postgres::password')
  $postgres_clients = lookup('profile::postgres::prefixes', {
    'value_type' => Array[Stdlib::IP::Address],
  })

  ::profile::firewall::permit { 'postgres':
    port     => 5432,
    prefixes => $postgres_clients,
  }

  class { '::postgresql::server':
    postgres_password => $password,
  }
}
