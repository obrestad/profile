class profile::webserver {
  class { 'apache':
    default_vhost => false,
  }

  apache::vhost { $::fqdn:
    port          => '80',
    docroot       => "/var/www/${::fqdn}",
    docroot_owner => 'www-data',
    docroot_group => 'www-data',
  }
}
