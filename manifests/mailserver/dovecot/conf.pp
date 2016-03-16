class profile::mailserver::dovecot::conf {
  $mailname = hiera('profile::mail::hostname')
  $dbname = hiera('profile::mail::db::name')
  $dbhost = hiera('profile::mail::db::host')
  $dbuser = hiera('profile::mail::db::user')
  $dbpass = hiera('profile::mail::db::pass')

  ini_setting { 'Dovecot protocols':
    ensure  => present,
    path    => '/etc/dovecot/dovecot.conf',
    setting => 'protocols',
    value   => 'imap pop3 lmtp',
  }

  ini_setting { 'Maildir location':
    ensure  => present,
    path    => '/etc/dovecot/conf.d/10-mail.conf',
    setting => 'mail_location',
    value   => 'maildir:/srv/mail/vhosts/%d/%n',
  }

  ini_setting { 'Maildir group':
    ensure  => present,
    path    => '/etc/dovecot/conf.d/10-mail.conf',
    setting => 'mail_privileged_group',
    value   => 'mail',
  }

  ini_setting { 'Dovecot-disable_plaintext_auth':
    ensure  => present,
    path    => '/etc/dovecot/conf.d/10-auth.conf',
    setting => 'disable_plaintext_auth',
    value   => 'yes',
  }

  ini_setting { 'Dovecot-auth_mechanisms':
    ensure  => present,
    path    => '/etc/dovecot/conf.d/10-auth.conf',
    setting => 'auth_mechanisms',
    value   => 'plain login',
  }

  ini_setting { 'dovecot auth-sql.conf.ext':
    ensure            => present,
    path              => '/etc/dovecot/conf.d/10-auth.conf',
    setting           => '!include',
    value             => 'auth-sql.conf.ext',
    key_val_separator => ' ',
  }

  ini_setting { 'dovecot sql driver':
    ensure  => present,
    path    => '/etc/dovecot/dovecot-sql.conf.ext',
    setting => 'driver',
    value   => 'mysql',
  }

  ini_setting { 'dovecot sql connect':
    ensure  => present,
    path    => '/etc/dovecot/dovecot-sql.conf.ext',
    setting => 'connect',
    value   => "host=${dbhost} dbname=${dbname} user=${dbuser} password=${dbpass}",
  }

  ini_setting { 'dovecot sql default_pass_scheme':
    ensure  => present,
    path    => '/etc/dovecot/dovecot-sql.conf.ext',
    setting => 'default_pass_scheme',
    value   => 'SHA512-CRYPT',
  }

  ini_setting { 'dovecot sql password':
    ensure  => present,
    path    => '/etc/dovecot/dovecot-sql.conf.ext',
    setting => 'password_query',
    value   => 'SELECT email as user, password FROM virtual_users WHERE email=\'%u\';',
  }

  ini_setting { 'dovecot ssl require':
    ensure  => present,
    path    => '/etc/dovecot/conf.d/10-ssl.conf',
    setting => 'ssl',
    value   => 'required',
  }

  ini_setting { 'dovecot ssl cert':
    ensure  => present,
    path    => '/etc/dovecot/conf.d/10-ssl.conf',
    setting => 'ssl_cert',
    value   => "/etc/letsencrypt/live/${mailname}/fullchain.pem",
  }

  ini_setting { 'dovecot ssl key':
    ensure  => present,
    path    => '/etc/dovecot/conf.d/10-ssl.conf',
    setting => 'ssl_key',
    value   => "/etc/letsencrypt/live/${mailname}/privkey.pem",
  }

  file { '/srv/mail/vhosts':
    ensure  => 'directory',
    owner   => 'vmail',
    group   => 'vmail',
    mode    => '2775',
  }

  file { '/etc/dovecot/conf.d/auth-sql.conf.ext':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/profile/config/dovecot/auth-sql.conf.ext',
  }

  file { '/etc/dovecot/conf.d/10-master.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/profile/config/dovecot/10-master.conf',
  }
}
