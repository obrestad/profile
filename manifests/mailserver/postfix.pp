class profile::mailserver::postfix {
  $mail_mynetworks = hiera('profile::mail::mynetworks')

  package { 'postfix':
    ensure => 'latest',
  }

  service { 'postfix':
    ensure => 'stopped',
  }
}
