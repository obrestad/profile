# Installs and configures the puppetdb server
class profile::puppet::db {
  $dbhost = lookup('profile::postgres::server')
  $dbname = lookup('profile::puppet::db::database::name', {
    'default_value' => 'puppetdb',
    'value_type'    => String,
  })
  $dbuser = lookup('profile::puppet::db::database::user', {
    'default_value' => 'puppetdb',
    'value_type'    => String,
  })
  $dbpass = lookup('profile::puppet::db::database::pass')

  class { '::puppetdb::server':
    database          => 'postgres',
    database_host     => $dbhost,
    database_username => $dbuser,
    database_password => $dbpass,
    database_name     => $dbname,
  }
}
