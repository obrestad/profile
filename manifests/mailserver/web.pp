# Configures the webserver used by the webmail-client, and requests SSL
# certificates for both the webserver and the mailserver.
class profile::mailserver::web {
  $mailname = hiera('profile::mail::hostname')
  $webmailname = hiera('profile::mail::webmail')
  $mysql_name = hiera('profile::mail::web::db::name')
  $mysql_host = hiera('profile::mail::web::db::host')
  $mysql_user = hiera('profile::mail::web::db::user')
  $mysql_pass = hiera('profile::mail::web::db::pass')
  $rc_des_key = hiera('profile::mail::web::deskey')

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

  apache::vhost { "${webmailname} http":
    servername    => $webmailname,
    port          => '80',
    docroot       => "/var/www/${webmailname}",
    docroot_owner => 'www-data',
    docroot_group => 'www-data',
  }
  apache::vhost { "${webmailname} https":
    servername    => $webmailname,
    port          => '443',
    docroot       => "/var/www/${webmailname}",
    ssl           => true,
    ssl_cert      => "/etc/letsencrypt/live/${webmailname}/fullchain.pem",
    ssl_key       => "/etc/letsencrypt/live/${webmailname}/privkey.pem",
    require       => Letsencrypt::Certonly[$webmailname],
  }

  letsencrypt::certonly { $webmailname:
    domains       => [$webmailname],
    plugin        => 'webroot',
    webroot_paths => ["/var/www/${webmailname}"],
    require       => Apache::Vhost["${webmailname} http"],
    manage_cron   => true,
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
    value   => "'ssl://${mailname}:993';",
    require => Package['roundcube'],
  }

  ini_setting { 'Roundcube SMTP Host':
    ensure  => present,
    path    => '/etc/roundcube/config.inc.php',
    setting => '$config[\'smtp_server\']',
    value   => "'${mailname}';",
    require => Package['roundcube'],
  }

  ini_setting { 'Roundcube SMTP Port':
    ensure  => present,
    path    => '/etc/roundcube/config.inc.php',
    setting => '$config[\'smtp_port\']',
    value   => '\'587\';',
    require => Package['roundcube'],
  }

  ini_setting { 'Roundcube SMTP User':
    ensure  => present,
    path    => '/etc/roundcube/config.inc.php',
    setting => '$config[\'smtp_user\']',
    value   => '\'%u\';',
    require => Package['roundcube'],
  }

  ini_setting { 'Roundcube SMTP Pass':
    ensure  => present,
    path    => '/etc/roundcube/config.inc.php',
    setting => '$config[\'smtp_pass\']',
    value   => '\'%p\';',
    require => Package['roundcube'],
  }

  ini_setting { 'Roundcube DES Key':
    ensure  => present,
    path    => '/etc/roundcube/config.inc.php',
    setting => '$config[\'des_key\']',
    value   => "'${rc_des_key}';",
    require => Package['roundcube'],
  }

  ini_setting { 'Roundcube DB Host':
    ensure  => present,
    path    => '/etc/roundcube/debian-db.php',
    setting => '$dbserver',
    value   => "'${mysql_host}';",
    require => Package['roundcube'],
  }

  ini_setting { 'Roundcube DB Name':
    ensure  => present,
    path    => '/etc/roundcube/debian-db.php',
    setting => '$dbname',
    value   => "'${mysql_name}';",
    require => Package['roundcube'],
  }

  ini_setting { 'Roundcube DB User':
    ensure  => present,
    path    => '/etc/roundcube/debian-db.php',
    setting => '$dbserver',
    value   => "'${mysql_user}';",
    require => Package['roundcube'],
  }

  ini_setting { 'Roundcube DB Pass':
    ensure  => present,
    path    => '/etc/roundcube/debian-db.php',
    setting => '$dbserver',
    value   => "'${mysql_pass}';",
    require => Package['roundcube'],
  }

  ini_setting { 'Roundcube DB Type':
    ensure  => present,
    path    => '/etc/roundcube/debian-db.php',
    setting => '$dbtype',
    value   => '\'mysql\';',
    require => Package['roundcube'],
  }
}
