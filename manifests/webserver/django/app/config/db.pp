# Configures a djangoapp to use a certain database.
define profile::webserver::django::app::config::db (
  String $dbhost,
  String $password,
  String $username = $name,
  String $dbname = $name,
) {
  $configfile = "/etc/${name}/settings.ini"

  ini_setting { "Djangoapp ${name} db type":
    ensure  => present,
    path    => $configfile,
    section => 'database',
    setting => 'type',
    value   => 'mysql',
    before  => Exec["/opt/${name}/manage.py migrate --noinput"],
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
    before  => Exec["/opt/${name}/manage.py migrate --noinput"],
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
    before  => Exec["/opt/${name}/manage.py migrate --noinput"],
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
    value   => $username,
    before  => Exec["/opt/${name}/manage.py migrate --noinput"],
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
    value   => $password,
    before  => Exec["/opt/${name}/manage.py migrate --noinput"],
    require => [
              Vcsrepo["/opt/${name}"],
              File["/etc/${name}"],
            ],
  }
}
