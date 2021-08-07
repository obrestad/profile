# Configures the database for the webmail-interface
class profile::mailserver::webmail::database {
  $mysql_name = lookup('profile::mailserver::web::db::name')
  $mysql_host = lookup('profile::mailserver::web::db::host')
  $mysql_user = lookup('profile::mailserver::web::db::user')
  $mysql_pass = lookup('profile::mailserver::web::db::pass')

  $schema = lookup('profile::mailserver::web::db::schema::apply', {
    'default_value' => false,
    'value_type'    => Boolean,
  })

  require ::profile::mailserver::webmail::install
  require ::profile::mysql::server

  if($schema) {
    $opt = { 'sql' => '/usr/share/roundcube/SQL/mysql.initial.sql' }
  } else {
    $opt = {}
  }

  mysql::db { $mysql_name:
    user     => $mysql_user,
    password => $mysql_pass,
    host     => $mysql_host,
    grant    => ['ALL'],
    *        => $opt,
  }

  profile::mysql::backup { $mysql_name:
    username => $mysql_user,
    password => $mysql_host,
  }
}
