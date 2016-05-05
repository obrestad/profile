class profile::telldus {
  firewall { '010 accept incoming telldus':
    proto  => 'tcp',
    dport  => [45002],
    action => 'accept',
  }
  #firewall { '010 v6 accept incoming HTTP(S)':
  #  proto    => 'tcp',
  #  dport    => [80, 443],
  #  action   => 'accept',
  #  provider => 'ip6tables',
  #}

  apache::vhost { 'ap.obrestad.org http':
    servername    => 'ap.obrestad.org',
    port          => '80',
    docroot       => '/var/www/ap.obrestad.org',
    docroot_owner => 'www-data',
    docroot_group => 'www-data',
  }
  apache::vhost { 'bp.obrestad.org http':
    servername    => 'bp.obrestad.org',
    port          => '80',
    docroot       => '/var/www/bp.obrestad.org',
    docroot_owner => 'www-data',
    docroot_group => 'www-data',
  }
}
