# This define installs a djangoapp 
define profile::webserver::django::apps::install {
  $sourcerepo = hiera("profile::web::djangoapp::${name}::sourcerepo")
  $dbname = hiera("profile::web::djangoapp::${name}::db::name")

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
      Mysql::Db[$dbname],
    ],
  }

  file { "/opt/${name}static":
    ensure => directory,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
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
