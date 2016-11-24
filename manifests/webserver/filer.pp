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

  #apache::vhost { "${::fqdn} https":
  #  servername    => $::fqdn,
  #  port          => '443',
  #  docroot       => "/var/www/${::fqdn}",
  #  ssl           => true,
  #  ssl_cert      => "/etc/letsencrypt/live/${::fqdn}/fullchain.pem",
  #  ssl_key       => "/etc/letsencrypt/live/${::fqdn}/privkey.pem",
  #}

  #letsencrypt::certonly { $::fqdn:
  #  domains       => [$::fqdn],
  #  plugin        => 'webroot',
  #  webroot_paths => ["/var/www/${::fqdn}"],
  #  require       => Apache::Vhost["${::fqdn} http"],
  #  manage_cron   => true,
  #}
}
