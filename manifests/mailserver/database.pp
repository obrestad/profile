# this class configures the mysql-database used by the mailserver. 
class profile::mailserver::database {
  $dbname = lookup('profile::mailserver::db::name')
  $dbhost = lookup('profile::mailserver::db::host')
  $dbuser = lookup('profile::mailserver::db::user')
  $dbpass = lookup('profile::mailserver::db::pass')

  include ::profile::mysql::server

  mysql::db { $dbname:
    user     => $dbuser,
    password => $dbpass,
    host     => $dbhost,
    grant    => ['CREATE', 'ALTER',
                  'DELETE', 'INSERT',
                  'SELECT', 'UPDATE',
                  'INDEX', 'DROP',
                ],
    require  => Class['::mysql::server'],
  }
}
