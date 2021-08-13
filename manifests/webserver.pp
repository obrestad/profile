# Installs an apache webserver and configures the firewall to allow HTTP and
# HTTPS traffic.
class profile::webserver {
  include ::profile::webserver::firewall
  require ::profile::webserver::hostcert
  include ::profile::webserver::sites

  class { 'apache':
    mpm_module => 'prefork',
    confd_dir  => '/etc/apache2/conf-enabled',
  }

  apache::vhost { "${::fqdn} http":
    servername    => $::fqdn,
    port          => '80',
    docroot       => "/var/www/${::fqdn}",
    docroot_owner => 'www-data',
    docroot_group => 'www-data',
  }

  apache::vhost { "${::fqdn} https":
    servername => $::fqdn,
    port       => '443',
    docroot    => "/var/www/${::fqdn}",
    ssl        => true,
    ssl_cert   => "/etc/letsencrypt/live/${::fqdn}/fullchain.pem",
    ssl_key    => "/etc/letsencrypt/live/${::fqdn}/privkey.pem",
  }
}
