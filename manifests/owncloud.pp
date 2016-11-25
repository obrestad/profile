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
    manage_repo   => false,
    db_pass       => $dbpass,
    db_user       => $dbuser,
    db_name       => $dbname,
    datadirectory => '/srv/owncloud-data',
    require       => Lvm::Logical_volume['owncloud_data'],
  }

  apt::source { 'owncloud':
    location => 'http://download.owncloud.org/download/repositories/stable/Debian_8.0/',
    release  => ' ',
    repos    => '/',
    key      => {
      id     => 'DDA2C105C4B73A6649AD2BBD47AE7F72479BC94B',
      source => 'https://download.owncloud.org/download/repositories/stable/Debian_8.0/Release.key',
    },
    before   => Class['::owncloud'],
  }

  lvm::logical_volume { 'owncloud_data':
    ensure            => present,
    volume_group      => 'hdd',
    size              => '100G',
    mountpath         => '/srv/owncloud-data',
    mountpath_require => true,
  }

  apache::vhost { "${url} http":
    servername      => $url,
    port            => '80',
    docroot         => '/var/www/owncloud/',
    docroot_owner   => 'www-data',
    docroot_group   => 'www-data',
    redirect_source => ['/'],
    redirect_dest   => ["https://${url}/"],
    redirect_status => ['permanent'],
  }

  apache::vhost { "${url} https":
    servername     => $url,
    port           => '443',
    docroot        => '/var/www/owncloud',
    manage_docroot => false,
    ssl            => true,
    ssl_cert       => "/etc/letsencrypt/live/${url}/fullchain.pem",
    ssl_key        => "/etc/letsencrypt/live/${url}/privkey.pem",
    require        => Letsencrypt::Certonly[$url],
    directories    => [
      { path            => '/var/www/owncloud',
        options         => ['Indexes', 'FollowSymLinks', 'MultiViews'],
        allow_override  => ['All'],
        require         => 'all granted',
        custom_fragment => 'Dav Off',
      },
    ],
  }

  letsencrypt::certonly { $url:
    domains       => [$url],
    plugin        => 'webroot',
    webroot_paths => ['/var/www/owncloud'],
    require       => Apache::Vhost["${url} http"],
    manage_cron   => true,
  }
}
