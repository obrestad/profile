class profile::mailserver::web {
  $mailname = hiera('profile::mail::hostname')

  apache::vhost { "${mailname} http":
    servername    => $mailname,
    port          => '80',
    docroot       => "/var/www/${mailname}",
    docroot_owner => 'www-data',
    docroot_group => 'www-data',
  }
  apache::vhost { "${mailname} https":
    servername    => $mailname,
    port          => '443',
    docroot       => "/var/www/${mailname}",
    ssl           => true,
    ssl_cert      => "/etc/letsencrypt/live/${mailname}/fullchain.pem",
    ssl_key       => "/etc/letsencrypt/live/${mailname}/privkey.pem",
    require       => Letsencrypt::Certonly[$mailname],
  }

  letsencrypt::certonly { $mailname:
    domains       => [$mailname],
    plugin        => 'webroot',
    webroot_paths => ["/var/www/${mailname}"],
    require       => Apache::Vhost["${mailname} http"],
    manage_cron   => true,
  }
}
