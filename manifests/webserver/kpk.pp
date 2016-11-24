# Sets up the webserver for kpk-ukraina
class profile::webserver::kpk {
  apache::vhost { 'www.kpk-ukraina.com http':
    servername    => 'www.kpk-ukraina.com',
    serveraliases => ['kpk-ukraina.com'],
    port          => '80',
    docroot       => '/var/www/www.kpk-ukraina.com',
    docroot_owner => 'www-data',
    docroot_group => 'www-data',
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
