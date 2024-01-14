# Configures a database for puppetdb
class profile::puppet::db::database {
  $dbname = lookup('profile::puppet::db::database::name', {
    'default_value' => 'puppetdb',
    'value_type'    => String,
  })
  $dbuser = lookup('profile::puppet::db::database::user', {
    'default_value' => 'puppetdb',
    'value_type'    => String,
  })
  $dbpass = lookup('profile::puppet::db::database::pass')

  ::postgresql::server::extension { 'pg_trgm':
    database  => $dbname,
  }

  postgresql::server::db { $dbname:
    user     => $dbuser,
    password => $dbpass,
    grant    => 'all',
    owner    => $dbuser,
  }
}
