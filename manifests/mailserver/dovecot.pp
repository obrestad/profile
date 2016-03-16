class profile::mailserver::dovecot {
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
}
