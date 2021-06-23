# Installs a certificate with the fqdn of the host
class profile::webserver::hostcert {
  profile::letsencrypt::certificate { $::fqdn:
    domains              => [ $::fqdn ],
    manage_cron          => true,
    cron_success_command => '/bin/systemctl reload apache2.service',
  }
}
