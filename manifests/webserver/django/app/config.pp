# Base-config for a django-application
define profile::webserver::django::app::config (
  String       $secret,
  Stdlib::Fqdn $url,
) {
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

  ini_setting { "Djangoapp ${name} mediapath":
    ensure  => present,
    path    => $configfile,
    section => 'general',
    setting => 'mediapath',
    value   => "/opt/${name}media",
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
