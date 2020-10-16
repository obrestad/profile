# Sets up the webserver for filer.rothaugane.com
class profile::webserver::filer {
  apache::vhost { 'filer.rothaugane.com http':
    servername      => 'filer.rothaugane.com',
    port            => '80',
    docroot         => '/home/eigil/www/filer.rothaugane.com',
    docroot_owner   => 'eigil',
    docroot_group   => 'www-data',
    require         => File['/home/eigil/www'],
    directories     => [
      { path            => '/home/eigil/www/filer.rothaugane.com',
        options         => ['Indexes', 'FollowSymLinks', 'MultiViews'],
        allow_override  => ['All'],
        require         => 'all granted',
      },
    ],
  }

  file { '/home/eigil/www':
    ensure   => 'directory',
    owner    => 'eigil',
    group    => 'www-data',
    mode     => '2755',
    require  => User['eigil'],
  }
}
