class profile::mailserver::postfix {
  $mailname = hiera('profile::mail::hostname')

  class { '::postfix':
    master_smtp       => 'smtp inet n - n - - smtpd',
    master_smtps      => 'smtps inet n - n - - smtpd',
    master_submission => 'submission inet n - n - - smtpd',
    mta               => true,
    relayhost         => 'direct',
  }

  # Various settings
  postfix::config {
    'myhostname':          value => $::fqdn;
    'recipient_delimiter': value => '-';
  }

  # Virtual mailbox settings
  postfix::config {
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
    'smtpd_tls_cert_file':
      value  => "/etc/letsencrypt/live/${::fqdn}/fullchain.pem";
    'smtpd_tls_key_file':
      value  => "/etc/letsencrypt/live/${::fqdn}/privkey.pem";
    'smtpd_tls_security_level':  value  => 'may';
  }
}
