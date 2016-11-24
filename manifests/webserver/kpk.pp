# Sets up the webserver for kpk-ukraina
class profile::webserver::kpk {
  $mysql_host = hiera('profile::webserver::kpk::mysql::host', 'localhost')
  $mysql_name = hiera('profile::webserver::kpk::mysql::name', 'kpk')
  $mysql_user = hiera('profile::webserver::kpk::mysql::user', 'kpk')
  $mysql_pass = hiera('profile::webserver::kpk::mysql::pass')

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

  mysql::db { $mysql_name:
    user           => $mysql_user,
    password       => $mysql_pass,
    host           => $mysql_host,
    grant          => ['CREATE', 'ALTER',
                        'DELETE', 'INSERT',
                        'SELECT', 'UPDATE',
                        'INDEX', 'DROP',
                      ],
    require        => Class['::mysql::server'],
  }
}
