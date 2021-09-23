# Requests and installs TLS-certificates for the mailserver. 
class profile::mailserver::certs {
  $mailname = lookup('profile::mailserver::name', String)

  profile::letsencrypt::certificate { $mailname:
    domains              => [ $mailname ],
    manage_cron          => true,
    cron_success_command => '/bin/systemctl reload apache2.service; /bin/systemctl reload dovecot.service;',
  }
}
