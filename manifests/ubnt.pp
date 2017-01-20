# Installs a ubnt controller
class profile::ubnt {
  $unifiurl = hiera('profile::unifi::url')

  apt::source { 'ubnt':
    location   => 'http://www.ubnt.com/downloads/unifi/debian',
    repos      => 'ubiquiti',
    release    => 'unifi5',
    key        => '4A228B2D358A5094178285BE06E85760C0A52C50',
    key_server => 'keyserver.ubuntu.com',
  }

  package { 'unifi':
    ensure  => 'present',
    require => Apt::Source['ubnt'],
  }

  service { 'unifi':
    ensure  => 'running',
    require => Package['unifi'],
  }

  firewall { '011 accept incoming UAPs and management':
    proto   => 'tcp',
    dport   => [8080, 8443],
    iniface => 'eth0',
    action  => 'accept',
  }
  firewall { '011 v6 accept incoming UAPs and management':
    proto    => 'tcp',
    dport    => [8080, 8443],
    action   => 'accept',
    iniface  => 'eth0',
    provider => 'ip6tables',
  }

  apache::vhost { "${unifiurl} http":
    servername      => $unifiurl,
    serveraliases   => [$unifiurl],
    port            => '80',
    docroot         => "/var/www/${unifiurl}",
    redirect_source => ['/'],
    redirect_dest   => ["https://${unifiurl}/"],
    redirect_status => ['permanent'],
  }

  letsencrypt::certonly { $unifiurl:
    domains       => [$unifiurl],
    plugin        => 'webroot',
    webroot_paths => ["/var/www/${unifiurl}"],
    require       => Apache::Vhost["${unifiurl} http"],
    manage_cron   => true,
  }

  apache::vhost { "${unifiurl} https":
    servername => $unifiurl,
    port       => '443',
    docroot    => "/var/www/${unifiurl}",
    ssl        => true,
    ssl_cert   => "/etc/letsencrypt/live/${unifiurl}/fullchain.pem",
    ssl_key    => "/etc/letsencrypt/live/${unifiurl}/privkey.pem",
  }

  file { '/usr/local/sbin/unifi-backup':
    owner  => 'root',
    group  => 'root',
    mode   => '0744',
    source => 'puppet:///modules/profile/scripts/unifi-backup.sh',
  }->
  cron { 'unifi-backup':
    command => '/usr/local/sbin/unifi-backup',
    user    => root,
    hour    => [3, 9, 15, 21],
    minute  => [49],
  }
}
