# Configures the webserver used by the webmail-client, and requests SSL
# certificates for both the webserver and the mailserver.
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
    require       => Letsencrypt::Certonly["${mailname}-${::fqdn}"],
  }

  letsencrypt::certonly { "${mailname}-${::fqdn}":
    domains       => [$mailname, $::fqdn],
    plugin        => 'webroot',
    webroot_paths => ["/var/www/${mailname}", "/var/www/${::fqdn}"],
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

  mysql::db { $mysql_name:
    user           => $mysql_user,
    password       => $mysql_pass,
    host           => $mysql_host,
    grant          => ['ALL'],
    require        => Class['::mysql::server'],
  }

  package { [
    'roundcube',
    'roundcube-core',
    'roundcube-mysql',
    'roundcube-plugins'
  ] :
    ensure => 'present',
  }

  ini_setting { 'Roundcube IMAP Host':
    ensure  => present,
    path    => '/etc/roundcube/config.inc.php',
    setting => '$config[\'default_host\']',
    value   => '\'mail.rothaugane.com\'',
    require => Package['roundcube'],
  }
}
