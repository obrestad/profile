# Configures the webserver used by the webmail-client, and requests SSL
# certificates. It also installs the mailadmin webinterface.
class profile::mailserver::web {
  $mailname = hiera('profile::mail::hostname')
  $webmailname = hiera('profile::mail::webmail')
  $mysql_name = hiera('profile::mail::db::name')
  $mysql_host = hiera('profile::mail::db::host')
  $mysql_user = hiera('profile::mail::db::user')
  $mysql_pass = hiera('profile::mail::db::pass')
  $django_secret = hiera('profile::mail::django::secret')

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
  package { 'python3-django':
    ensure => 'present',
  }
  package { 'python3-mysqldb':
    ensure => 'present',
  }

  vcsrepo { '/opt/mailadmin':
    ensure   => present,
    provider => git,
    source   => 'git://git.rothaugane.com/mailadmin.git',
  }

  ini_setting { 'Mailadmin debug':
    ensure  => present,
    path    => '/opt/mailadmin/settings.ini',
    section => 'general',
    setting => 'debug',
    value   => false,
    require => Vcsrepo['/opt/mailadmin'],
  }

  ini_setting { 'Mailadmin django secret':
    ensure  => present,
    path    => '/opt/mailadmin/settings.ini',
    section => 'general',
    setting => 'secret',
    value   => $django_secret,
    require => Vcsrepo['/opt/mailadmin'],
  }

  ini_setting { 'Mailadmin db type':
    ensure  => present,
    path    => '/opt/mailadmin/settings.ini',
    section => 'database',
    setting => 'type',
    value   => 'mysql',
    require => Vcsrepo['/opt/mailadmin'],
  }

  ini_setting { 'Mailadmin db host':
    ensure  => present,
    path    => '/opt/mailadmin/settings.ini',
    section => 'database',
    setting => 'host',
    value   => $mysql_host,
    require => Vcsrepo['/opt/mailadmin'],
  }

  ini_setting { 'Mailadmin db name':
    ensure  => present,
    path    => '/opt/mailadmin/settings.ini',
    section => 'database',
    setting => 'name',
    value   => $mysql_name,
    require => Vcsrepo['/opt/mailadmin'],
  }

  ini_setting { 'Mailadmin db user':
    ensure  => present,
    path    => '/opt/mailadmin/settings.ini',
    section => 'database',
    setting => 'user',
    value   => $mysql_user,
    require => Vcsrepo['/opt/mailadmin'],
  }

  ini_setting { 'Mailadmin db password':
    ensure  => present,
    path    => '/opt/mailadmin/settings.ini',
    section => 'database',
    setting => 'password',
    value   => $mysql_pass,
    require => Vcsrepo['/opt/mailadmin'],
  }
}
