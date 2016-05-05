class profile::mailserver::web {
  $mailname = hiera('profile::mail::hostname')
  $webmailurl = hiera('profile::mail::webmail')
  $mysql_name = hiera('profile::mail::web::db::name')
  $mysql_host = hiera('profile::mail::web::db::host')
  $mysql_user = hiera('profile::mail::web::db::user')
  $mysql_pass = hiera('profile::mail::web::db::pass')

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
    require       => Letsencrypt::Certonly["${::fqdn}-${mailname}"],
  }

  letsencrypt::certonly { "${::fqdn}-${mailname}":
    domains       => [$::fqdn, $mailname],
    plugin        => 'webroot',
    webroot_paths => ["/var/www/${::fqdn}", "/var/www/${mailname}"],
    require       => Apache::Vhost["${mailname} http"],
    manage_cron   => true,
  }

  apache::vhost { "${webmailurl} http":
    servername    => $mailname,
    port          => '80',
    docroot       => "/var/www/${webmailurl}",
    docroot_owner => 'www-data',
    docroot_group => 'www-data',
  }
#  apache::vhost { "${webmailurl} https":
#    servername    => $mailname,
#    port          => '443',
#    docroot       => "/var/www/${webmailurl}",
#    ssl           => true,
#    ssl_cert      => "/etc/letsencrypt/live/${webmailurl}/fullchain.pem",
#    ssl_key       => "/etc/letsencrypt/live/${webmailurl}/privkey.pem",
#    require       => Letsencrypt::Certonly["${webmailurl}"],
#  }

#  letsencrypt::certonly { "${webmailurl}":
#    domains       => [$webmailurl],
#    plugin        => 'webroot',
#    webroot_paths => ["/var/www/${webmailurl}"],
#    require       => Apache::Vhost["${webmailurl} http"],
#    manage_cron   => true,
#  }

  mysql::db { $mysql_name:
    user           => $mysql_user,
    password       => $mysql_pass,
    host           => $mysql_host,
    grant          => ['ALL'],
    require        => Class['::mysql::server'],
  }
}
