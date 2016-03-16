class profile::mailserver::dovecot::conf {
  $dbname = hiera('profile::mail::db::name')
  $dbhost = hiera('profile::mail::db::host')
  $dbuser = hiera('profile::mail::db::user')
  $dbpass = hiera('profile::mail::db::pass')

  ini_setting { 'Dovecot protocols':
    ensure  => present,
    path    => '/etc/dovecot/dovecot.conf',
    setting => 'protocols',
    value   => 'imap pop3 lmtp',
    notify  => Service['dovecot'],
  }

  ini_setting { 'Maildir location':
    ensure  => present,
    path    => '/etc/dovecot/conf.d/10-mail.conf',
    setting => 'mail_location',
    value   => 'maildir:/srv/mail/vhosts/%d/%n',
    notify  => Service['dovecot'],
  }

  ini_setting { 'Maildir group':
    ensure  => present,
    path    => '/etc/dovecot/conf.d/10-mail.conf',
    setting => 'mail_privileged_group',
    value   => 'mail',
    notify  => Service['dovecot'],
  }

  ini_setting { 'Dovecot-disable_plaintext_auth':
    ensure  => present,
    path    => '/etc/dovecot/conf.d/10-auth.conf',
    setting => 'disable_plaintext_auth',
    value   => 'yes',
    notify  => Service['dovecot'],
  }

  ini_setting { 'Dovecot-auth_mechanisms':
    ensure  => present,
    path    => '/etc/dovecot/conf.d/10-auth.conf',
    setting => 'auth_mechanisms',
    value   => 'plain login',
    notify  => Service['dovecot'],
  }

  ini_setting { 'dovecot auth-sql.conf.ext':
    ensure            => present,
    path              => '/etc/dovecot/conf.d/10-auth.conf',
    setting           => '!include',
    value             => 'auth-sql.conf.ext',
    key_val_separator => ' ',
    notify            => Service['dovecot'],
  }

  ini_setting { 'dovecot sql driver':
    ensure  => present,
    path    => '/etc/dovecot/dovecot-sql.conf.ext',
    setting => 'driver',
    value   => 'mysql',
    notify  => Service['dovecot'],
  }

  ini_setting { 'dovecot sql connect':
    ensure  => present,
    path    => '/etc/dovecot/dovecot-sql.conf.ext',
    setting => 'connect',
    value   => "host=${dbhost} dbname=${dbname} user=${dbuser} password=${dbpass}",
    notify  => Service['dovecot'],
  }

  ini_setting { 'dovecot sql default_pass_scheme':
    ensure  => present,
    path    => '/etc/dovecot/dovecot-sql.conf.ext',
    setting => 'default_pass_scheme',
    value   => 'SHA512-CRYPT',
    notify  => Service['dovecot'],
  }

  ini_setting { 'dovecot sql password':
    ensure  => present,
    path    => '/etc/dovecot/dovecot-sql.conf.ext',
    setting => 'password_query',
    value   => 'SELECT email as user, password FROM virtual_users WHERE email=\'%u\';',
    notify  => Service['dovecot'],
  }

  file { '/srv/mail/vhosts':
    ensure  => 'directory',
    user    => 'vmail',
    group   => 'vmail',
    mode    => '2775',
  }

  file { '/etc/dovecot/conf.d/auth-sql.conf.ext':
    user    => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/profile/config/dovecot/auth-sql.conf.ext',
  }
}
