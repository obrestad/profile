class profile::webserver {
  class { 'apache':
    default_vhost => false,
  }

  apache::vhost { "${::fqdn} http":
    servername    => $::fqdn,
    port          => '80',
    docroot       => "/var/www/${::fqdn}",
    docroot_owner => 'www-data',
    docroot_group => 'www-data',
  }
  apache::vhost { "${::fqdn} https":
    servername    => $::fqdn,
    port          => '443',
    docroot       => "/var/www/${::fqdn}",
    ssl           => true,
    ssl_cert      => "/etc/letsencrypt/live/${::fqdn}/fullchain.pem",
    ssl_key       => "/etc/letsencrypt/live/${::fqdn}/privkey.pem",
  }

  firewall { '010 accept incoming HTTP(S)':
    proto  => 'tcp',
    dport  => [80, 443],
    action => 'accept',
  }

  class { '::letsencrypt':
    email => 'hostmaster@rothaugane.com',
  }

  letsencrypt::certonly { $::fqdn:
    domains       => [$::fqdn],
    plugin        => 'webroot',
    webroot_paths => ["/var/www/${::fqdn}"],
    require       => Apache::Vhost["${::fqdn} http"],
    manage_cron   => true,
  }
}