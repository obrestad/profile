# This define creates an apache vhost for a django application, and optionally
# installs a letsencrypt certificate and configures 
define profile::webserver::django::apps::vhost {
  $url = hiera("profile::web::djangoapp::${name}::url")
  $appname = hiera("profile::web::djangoapp::${name}::appname", $name)
  $ssl = hiera("profile::web::djangoapp::${name}::ssl", true)

  if($ssl) {
    apache::vhost { "${url} http":
      servername      => $url,
      port            => '80',
      docroot         => "/var/www/${url}",
      redirect_source => ['/'],
      redirect_dest   => ["https://${url}/"],
      redirect_status => ['permanent'],
    }
    apache::vhost { "${url} https":
      servername          => $url,
      port                => '443',
      docroot             => "/var/www/${url}",
      ssl                 => true,
      ssl_cert            => "/etc/letsencrypt/live/${url}/fullchain.pem",
      ssl_key             => "/etc/letsencrypt/live/${url}/privkey.pem",
      require             => Letsencrypt::Certonly["${url}-${::fqdn}"],
      directories         => [
        { path    => "/opt/${name}static/",
          require => 'all granted',
        },
        { path    => "/var/www/${url}/.well-known/",
          require => 'all granted',
        },
      ],
      custom_fragment     => "
    <Directory /opt/${name}/${appname}>
      <Files wsgi.py>
        Require all granted
      </Files>
    </Directory>",
      wsgi_script_aliases => { '/' => "/opt/${name}/${appname}/wsgi.py" },
      aliases             => [
        { alias => '/static/',
          path  => "/opt/${name}static/",
        },
      ],
    }

    letsencrypt::certonly { "${url}-${::fqdn}":
      domains       => [$url, $::fqdn],
      plugin        => 'webroot',
      webroot_paths => ["/var/www/${url}", "/var/www/${::fqdn}"],
      require       => Apache::Vhost["${url} http"],
      manage_cron   => true,
    }

    file { "/var/www/${url}/.well-known":
      ensure => directory,
      mode   => '0750',
      owner  => 'www-data',
      group  => 'www-data',
    }
  } else {
    apache::vhost { "${url} http":
      servername          => $url,
      port                => '80',
      docroot             => "/var/www/${url}",
      directories         => [
        { path    => "/opt/${name}static/",
          require => 'all granted',
        },
      ],
      custom_fragment     => "
    <Directory /opt/${name}/${appname}>
      <Files wsgi.py>
        Require all granted
      </Files>
    </Directory>",
      wsgi_script_aliases => { '/' => "/opt/${name}/${appname}/wsgi.py" },
      aliases             => [
        { alias => '/static/',
          path  => "/opt/${name}static/",
        },
      ],
    }
  }
}
