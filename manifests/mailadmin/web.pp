# This class configures the apache vhost for the mailadmin app.
class profile::mailadmin::web {
  $url = hiera('profile::mailserver::name')

  require ::profile::mailserver::certs
  require ::profile::webserver

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
    directories         => [
      { path    => '/opt/mailadminstatic/',
        require => 'all granted',
      },
    ],
    custom_fragment     => "
  <Directory /opt/mailadmin/mailadmin>
    <Files wsgi.py>
      Require all granted
    </Files>
  </Directory>",
    wsgi_script_aliases => { '/' => '/opt/mailadmin/mailadmin/wsgi.py' },
    aliases             => [
      { alias => '/static/',
        path  => '/opt/mailadminstatic/',
      },
    ],
  }

  class { 'apache::mod::wsgi':
    package_name     => 'libapache2-mod-wsgi-py3',
    mod_path         => '/usr/lib/apache2/modules/mod_wsgi.so',
    wsgi_python_path => '/opt/mailadmin',
  }
}
