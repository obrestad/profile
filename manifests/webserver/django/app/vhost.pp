# This define creates an apache vhost for a django application, and optionally
# installs a letsencrypt certificate and configures and configures a HTTP vhost
# redirecting to the HTTPS vhost
define profile::webserver::django::app::vhost (
  String  $url,
  String  $appname = $name,
  Boolean $tls     = true,
) {
  if($tls) {
    $tlsoptions = {
      'ssl'      => true,
      'ssl_cert' => "/etc/letsencrypt/live/${url}/fullchain.pem",
      'ssl_key'  => "/etc/letsencrypt/live/${url}/privkey.pem",
    }

    ::profile::letsencrypt::certificate { $url,
      before               => Apache::Vhost["Djangoapp-${url}"],
      cron_success_command => '/bin/systemctl reload apache2.service',
      domains              => [ $url ],
      manage_cron          => true,
    }

    apache::vhost { "${url} HTTPS redirect":
      servername      => $url,
      port            => '80',
      docroot         => "/var/www/${url}",
      redirect_source => ['/'],
      redirect_dest   => ["https://${url}/"],
      redirect_status => ['permanent'],
    }
  } else {
    $tlsoptions = {
      'ssl' => false,
    }
  }

  apache::vhost { "Djangoapp-${url}":
    servername          => $url,
    port                => '443',
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
    *                   => $tlsoptions,
  }
}
