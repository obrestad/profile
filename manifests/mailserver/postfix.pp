# Installs and configures the postfix smtp for mailserver use.
class profile::mailserver::postfix {
  $mailname = lookup('profile::mailserver::name', String)
  $mynetworks = lookup('profile::mail::mynetworks', Array[String])

  require ::profile::mailserver::certs
  include ::profile::mailserver::mysql
  include ::profile::mailserver::firewall::smtp

  package { 'postfix-mysql':
    ensure  => 'present',
  }

  class { '::postfix':
    master_smtp       => 'smtp inet n - n - - smtpd
  -o smtpd_recipient_restrictions=reject_invalid_helo_hostname,reject_non_fqdn_sender,reject_unknown_sender_domain,reject_non_fqdn_recipient,reject_unknown_recipient_domain,reject_unauth_destination,reject_rbl_client,zen.spamhaus.org,permit
  -o smtpd_helo_required=yes
  -o disable_vrfy_command=yes
  -o content_filter=spamassassin',
    master_submission => 'submission inet n - n - - smtpd
  -o syslog_name=postfix/submission
  -o smtpd_tls_security_level=encrypt
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_tls_auth_only=yes
  -o smtpd_reject_unlisted_recipient=no
  -o smtpd_client_restrictions=permit_sasl_authenticated,permit_mynetworks,reject
  -o smtpd_helo_restrictions=
  -o smtpd_sender_restrictions=
  -o smtpd_recipient_restrictions=
  -o smtpd_relay_restrictions=permit_sasl_authenticated,reject_unauth_destination,reject
  -o milter_macro_daemon_name=ORIGINATING
  -o disable_vrfy_command=yes
  -o content_filter=spamassassin
spamassassin unix - n n - - pipe
  user=debian-spamd argv=/usr/bin/spamc -f -e /usr/sbin/sendmail -oi -f ${sender} ${recipient}',
  }

  # Various settings
  postfix::config {
    'myhostname':          value => $::fqdn;
    'mydestination':       value => $::fqdn;
    'mynetworks':          value => join($mynetworks, ' ');
    'recipient_delimiter': value => '-';
    'relayhost':           ensure => 'blank';
    'message_size_limit':  value => '104857600';
    'tls_ssl_options':     value => 'NO_COMPRESSION, NO_RENEGOTIATION';
  }

  # SASL
  postfix::config {
    'smtpd_sasl_type':        value => 'dovecot';
    'smtpd_sasl_path':        value => 'private/auth';
    'smtpd_sasl_auth_enable': value => 'yes';
  }

  $mysql_virt_alias = 'mysql:/etc/postfix/mysql-virtual-alias-maps.cf'
  $mysql_virt_mailto = 'mysql:/etc/postfix/mysql-virtual-email2email.cf'

  # Virtual mailbox settings
  postfix::config {
    'virtual_transport':
      value => 'lmtp:unix:private/dovecot-lmtp';
    'virtual_mailbox_domains':
      value => 'mysql:/etc/postfix/mysql-virtual-mailbox-domains.cf';
    'virtual_mailbox_maps':
      value => 'mysql:/etc/postfix/mysql-virtual-mailbox-maps.cf';
    'virtual_alias_maps':
      value => "${mysql_virt_alias}, ${mysql_virt_mailto}"
  }

  $restriction_permit = 'permit_sasl_authenticated, permit_mynetworks'
  # Deny relay access etc.
  postfix::config {
    'smtpd_recipient_restrictions':
      value => "${restriction_permit}, defer_unauth_destination";
    'smtpd_relay_restrictions':
      value => "${restriction_permit}, defer_unauth_destination";
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
    'smtp_tls_security_level':  value  => 'may';
  }
}
