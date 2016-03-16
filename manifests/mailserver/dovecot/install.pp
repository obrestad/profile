class profile::mailserver::dovecot::install {
  package { 'dovecot-core':
    ensure  => 'present',
  }

  package { 'dovecot-imapd':
    ensure  => 'present',
  }

  package { 'dovecot-lmtpd':
    ensure  => 'present',
  }

  package { 'dovecot-mysql':
    ensure  => 'present',
  }

  exec { 'dovecot':
    command     => 'echo "dovecot packages are installed"',
    path        => '/usr/sbin:/bin:/usr/bin:/sbin',
    logoutput   => true,
    refreshonly => true,
    require     => Package['dovecot-core'],
  }

  service { 'dovecot':
    ensure  => running,
    require => Exec['dovecot'],
    enable  => true
  }

  group { 'vmail':
    ensure => present,
    gid    => 5000,
  }

  user { 'vmail':
    ensure      => present,
    gid         => 'vmail',
    require     => Group['vmail'],
    uid         => 5000,
    shell       => '/bin/false',
    home        => '/srv/mail/vhosts',
    password    => '*',
  }
}
