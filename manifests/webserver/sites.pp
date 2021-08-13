# Configures vhosts for simple websites 
class profile::webserver::sites {
  $sites = lookup('profile::webserver::sites', {
    'default_value' => {},
    'value_type'    => Hash[String, Hash],
  })

  $sites.each | $domain, $data | {
    profile::letsencrypt::certificate { $domain:
      domains              => [ $domain ],
      manage_cron          => true,
      cron_success_command => '/bin/systemctl reload apache2.service',
    }

    apache::vhost { "${domain} http":
      servername    => $domain,
      port          => '80',
      docroot       => $data['docroot'], 
      docroot_owner => $data['owner'],
      docroot_group => $data['group'],
    }

    apache::vhost { "${domain} https":
      servername => $domain,
      port       => '443',
      docroot       => $data['docroot'], 
      ssl        => true,
      ssl_cert   => "/etc/letsencrypt/live/${domain}/fullchain.pem",
      ssl_key    => "/etc/letsencrypt/live/${domain}/privkey.pem",
    }
  }
}
