# This class installs owncloud, and sets up lvm, mysql and apache to support
# owncloud properly.
class profile::owncloud {
  $url = hiera('profile::owncloud::url')
  $dbname = hiera('profile::owncloud::db::name', 'owncloud')
  $dbuser = hiera('profile::owncloud::db::name', 'owncloud')
  $dbpass = hiera('profile::owncloud::db::pass')

  class { '::owncloud':
    manage_apache => false,
    manage_vhost  => false,
    db_pass       => $dbpass,
    db_user       => $dbuser,
    db_name       => $dbname,
    datadirectory => '/srv/owncloud-data',
    require       => Lvm::Logical_volume['owncloud_data'],
  }

  lvm::logical_volume { 'owncloud_data':
    ensure            => present,
    volume_group      => 'hdd',
    size              => '100G',
    mountpath         => '/srv/owncloud-data',
    mountpath_require => true,
  }

  apache::vhost { "${url} http":
    servername    => $url,
    port          => '80',
    docroot       => '/var/www/owncloud/',
    docroot_owner => 'www-data',
    docroot_group => 'www-data',
    directories   => [
      { path            => '/var/www/owncloud',
        options         => ['Indexes', 'FollowSymLinks', 'MultiViews'],
        allow_override  => ['All'],
        require         => 'all granted',
        custom_fragment => 'Dav Off',
      },
    ],
  }
}
