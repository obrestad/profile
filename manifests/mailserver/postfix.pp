class profile::mailserver::postfix {
  $mailname = hiera('profile::mail::hostname')

  package { 'postfix-mysql':
    ensure  => 'present',
  }

  class { '::postfix':
    master_smtp       => 'smtp inet n - n - - smtpd',
    master_smtps      => 'smtps inet n - n - - smtpd
  -o syslog_name=postfix/smtps
  -o smtpd_tls_wrappermode=yes
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_client_restrictions=permit_sasl_authenticated,reject
  -o milter_macro_daemon_name=ORIGINATING',
    master_submission => 'submission inet n - n - - smtpd
  -o syslog_name=postfix/submission
  -o smtpd_tls_security_level=encrypt
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_client_restrictions=permit_sasl_authenticated,reject
  -o milter_macro_daemon_name=ORIGINATING',
  }

  # Various settings
  postfix::config {
    'myhostname':          value => $::fqdn;
    'mydestination':       value => $::fqdn;
    'mynetworks':          value => '127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128';
    'recipient_delimiter': value => '-';
    'relayhost':           ensure => 'blank';
  }

  # SASL
  postfix::config {
    'smtpd_sasl_type':        value => 'dovecot'
    'smtpd_sasl_path':        value => 'private/auth'
    'smtpd_sasl_auth_enable': value => 'yes'
  }
  # Virtual mailbox settings
  postfix::config {
    'virtual_transport':
      value => 'lmtp:unix:private/dovecot-lmtp';
    'virtual_mailbox_domains':
      value => 'mysql:/etc/postfix/mysql-virtual-mailbox-domains.cf';
    'virtual_mailbox_maps':
      value => 'mysql:/etc/postfix/mysql-virtual-mailbox-maps.cf';
    'virtual_alias_maps':
      value => 'mysql:/etc/postfix/mysql-virtual-alias-maps.cf, mysql:/etc/postfix/mysql-virtual-email2email.cf';
  }

  # Deny relay access etc.
  postfix::config {
    'smtpd_recipient_restrictions':
      value => 'permit_sasl_authenticated, permit_mynetworks, defer_unauth_destination';
    'smtpd_relay_restrictions':
      value => 'permit_sasl_authenticated, permit_mynetworks, defer_unauth_destination';
  }

  # Implement TLS
  postfix::config {
    'smtpd_tls_CAfile':
      value  => "/etc/letsencrypt/live/${mailname}/chain.pem";
    'smtpd_tls_cert_file':
      value  => "/etc/letsencrypt/live/${mailname}/cert.pem";
    'smtpd_tls_key_file':
      value  => "/etc/letsencrypt/live/${mailname}/privkey.pem";
    'smtpd_tls_security_level':  value  => 'may';
  }
}
