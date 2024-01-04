# This define installs a djangoapp 
define profile::webserver::django::app::install (
  String $sourcerepo,
) {
  vcsrepo { "/opt/${name}":
    ensure   => latest,
    provider => 'git',
    source   => $sourcerepo,
    revision => 'master',
    notify   => [
      Exec["/opt/${name}/manage.py migrate --noinput"],
      Exec["/opt/${name}/manage.py collectstatic --noinput"],
      Service['httpd'],
    ],
  }

  exec { "/opt/${name}/manage.py migrate --noinput":
    refreshonly => true,
    require     => [
      Vcsrepo["/opt/${name}"],
    ],
  }

  file { "/opt/${name}static":
    ensure => directory,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  file { "/opt/${name}media":
    ensure => directory,
    mode   => '0755',
    owner  => 'www-data',
    group  => 'www-data',
  }

  exec { "/opt/${name}/manage.py collectstatic --noinput":
    refreshonly => true,
    require     => [
      Vcsrepo["/opt/${name}"],
      File["/opt/${name}static"],
    ],
  }

  file { "/etc/${name}":
    ensure => directory,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }
}
