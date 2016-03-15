class profile::mailserver::postfix {
  $mailname = hiera('profile::mail::hostname')

  class { '::postfix':
    master_smtp => 'smtp inet n - n - - smtpd',
    master_smtps => 'smtps inet n - n - - smtpd',
    master_submission => 'submission inet n - n - - smtpd',
    mta => true,
	relayhost => 'direct',
  }
  postfix::config { 'myhostname':
    ensure  => present,
    value   => $::fqdn,
  }

  postfix::config {
    'smtpd_tls_cert_file':       value  => "/etc/letsencrypt/live/${mailname}/fullchain.pem";
    'smtpd_tls_key_file':        value  => "/etc/letsencrypt/live/${mailname}/privkey.pem";
    'smtpd_tls_security_level':  value  => 'may';
  }
}
