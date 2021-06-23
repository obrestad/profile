# This class installs the mailadmin webinterface 
class profile::mailadmin::install {
  include ::profile::mailadmin::database
  include ::profile::mailserver::database

  vcsrepo { '/opt/mailadmin':
    ensure   => latest,
    provider => 'git',
    source   => 'git://git.rothaugane.com/mailadmin.git',
    revision => 'master',
    notify   => [
      Exec['/opt/mailadmin/manage.py migrate --noinput'],
      Exec['/opt/mailadmin/manage.py collectstatic --noinput'],
      Service['httpd'],
    ],
  }

  exec { '/opt/mailadmin/manage.py migrate --noinput':
    refreshonly => true,
    require     => [
      Vcsrepo['/opt/mailadmin'],
      Mysql::Db['mail'],
    ],
  }

  file { '/opt/mailadminstatic':
    ensure => directory,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  exec { '/opt/mailadmin/manage.py collectstatic --noinput':
    refreshonly => true,
    require     => [
      Vcsrepo['/opt/mailadmin'],
      File['/opt/mailadminstatic'],
    ],
  }

  file { '/etc/mailadmin':
    ensure => directory,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }
}
