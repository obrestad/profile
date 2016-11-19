# Installs an apache webserver and configures the firewall to allow HTTP and
# HTTPS traffic.
class profile::webserver {
  class { 'apache':
    default_vhost => false,
    mpm_module    => 'prefork',
  }

  include '::apache::mod::php'
  include '::apache::mod::rewrite'
  include '::apache::mod::ssl'

  class { 'apache::mod::wsgi':
    wsgi_python_path => '/opt/mailadmin/',
    package_name     => 'libapache2-mod-wsgi-py3',
    mod_path         => '/usr/lib/apache2/modules/mod_wsgi.so',
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
  firewall { '010 v6 accept incoming HTTP(S)':
    proto    => 'tcp',
    dport    => [80, 443],
    action   => 'accept',
    provider => 'ip6tables',
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
