# This definec creates a mysql database, and configures a djangoapp to use it
define profile::webserver::django::apps::database {
  $dbname = hiera("profile::web::djangoapp::${name}::db::name")
  $dbhost = hiera("profile::web::djangoapp::${name}::db::host")
  $dbuser = hiera("profile::web::djangoapp::${name}::db::user")
  $dbpass = hiera("profile::web::djangoapp::${name}::db::pass")

  $installpath = "/opt/${name}"
  $configfile = "/etc/${name}/settings.ini"

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

  ini_setting { "Djangoapp ${name} db type":
    ensure  => present,
    path    => $configfile,
    section => 'database',
    setting => 'type',
    value   => 'mysql',
    require => [
              Vcsrepo["/opt/${name}"],
              File["/etc/${name}"],
            ],
  }

  ini_setting { "Djangoapp ${name} db host":
    ensure  => present,
    path    => $configfile,
    section => 'database',
    setting => 'host',
    value   => $dbhost,
    require => [
              Vcsrepo["/opt/${name}"],
              File["/etc/${name}"],
            ],
  }

  ini_setting { "Djangoapp ${name} db name":
    ensure  => present,
    path    => $configfile,
    section => 'database',
    setting => 'name',
    value   => $dbname,
    require => [
              Vcsrepo["/opt/${name}"],
              File["/etc/${name}"],
            ],
  }

  ini_setting { "Djangoapp ${name} db user":
    ensure  => present,
    path    => $configfile,
    section => 'database',
    setting => 'user',
    value   => $dbuser,
    require => [
              Vcsrepo["/opt/${name}"],
              File["/etc/${name}"],
            ],
  }

  ini_setting { "Djangoapp ${name} db password":
    ensure  => present,
    path    => $configfile,
    section => 'database',
    setting => 'password',
    value   => $dbpass,
    require => [
              Vcsrepo["/opt/${name}"],
              File["/etc/${name}"],
            ],
  }
}
