# Configures the database for the webmail-interface
class profile::mailserver::webmail::database {
  $mysql_name = hiera('profile::mailserver::web::db::name')
  $mysql_host = hiera('profile::mailserver::web::db::host')
  $mysql_user = hiera('profile::mailserver::web::db::user')
  $mysql_pass = hiera('profile::mailserver::web::db::pass')

  require ::profile::mailserver::webmail::install
  require ::profile::mysql::server

  mysql::db { $mysql_name:
    user     => $mysql_user,
    password => $mysql_pass,
    host     => $mysql_host,
    grant    => ['ALL'],
    sql      => '/usr/share/roundcube/SQL/mysql.initial.sql',
  }
}
