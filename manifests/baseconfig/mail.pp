# Install postfix in sattelite mode, and configures it to relay mails trough a
# mailserver.
class profile::baseconfig::mail {
  $relay = hiera('profile::mail::relayhost')
  $rootmail = hiera('profile::mail::recipient')

  include ::augeas

  class { '::postfix':
    inet_interfaces     => '127.0.0.1',
    mynetworks          => '127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128',
    relayhost           => $relay,
    root_mail_recipient => $rootmail,
    satellite           => true,
    smtp_listen         => '127.0.0.1',
  }
  postfix::config {
    'smtp_tls_security_level':  value  => 'may';
  }
}
