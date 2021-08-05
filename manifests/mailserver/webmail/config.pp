# Configures roundcube
class profile::mailserver::webmail::config {
  $mailname = hiera('profile::mailserver::name')
  $mysql_name = hiera('profile::mailserver::web::db::name')
  $mysql_host = hiera('profile::mailserver::web::db::host')
  $mysql_user = hiera('profile::mailserver::web::db::user')
  $mysql_pass = hiera('profile::mailserver::web::db::pass')
  $rc_des_key = hiera('profile::mailserver::web::deskey')

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
    value   => "'tls://${mailname}';",
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

  ini_setting { 'Roundcube DBC Disable':
    ensure  => present,
    path    => '/etc/dbconfig-common/roundcube.conf',
    setting => 'dbc_install',
    value   => false,
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
    setting => '$dbuser',
    value   => "'${mysql_user}';",
    require => Package['roundcube'],
  }

  ini_setting { 'Roundcube DB Pass':
    ensure  => present,
    path    => '/etc/roundcube/debian-db.php',
    setting => '$dbpass',
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
