# This define configures a django app 
define profile::webserver::django::apps::configure {
  $secret = hiera("profile::web::djangoapp::${name}::djangosecret")
  $url = hiera("profile::web::djangoapp::${name}::url")

  $configfile = "/etc/${name}/settings.ini"

  ini_setting { "Djangoapp ${name} debug":
    ensure  => present,
    path    => $configfile,
    section => 'general',
    setting => 'debug',
    value   => false,
    require => [
              Vcsrepo["/opt/${name}"],
              File["/etc/${name}"],
            ],
  }

  ini_setting { "Djangoapp ${name} django secret":
    ensure  => present,
    path    => $configfile,
    section => 'general',
    setting => 'secret',
    value   => $secret,
    require => [
              Vcsrepo["/opt/${name}"],
              File["/etc/${name}"],
            ],
  }

  ini_setting { "Djangoapp ${name} main host":
    ensure  => present,
    path    => $configfile,
    section => 'hosts',
    setting => 'main',
    value   => $url,
    require => [
              Vcsrepo["/opt/${name}"],
              File["/etc/${name}"],
            ],
  }

  ini_setting { "Djangoapp ${name} staticpath":
    ensure  => present,
    path    => $configfile,
    section => 'general',
    setting => 'staticpath',
    value   => "/opt/${name}static",
    require => [
              Vcsrepo["/opt/${name}"],
              File["/etc/${name}"],
            ],
    before  => Exec["/opt/${name}/manage.py collectstatic --noinput"],
  }
}
