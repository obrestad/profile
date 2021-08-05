# Retrieves certs for the webmail vhost
class profile::mailserver::webmail::certs {
  $webmailname = hiera('profile::mailserver::web::name')

  profile::letsencrypt::certificate { $webmailname:
    domains              => [ $webmailname ],
    manage_cron          => true,
    cron_success_command => '/bin/systemctl reload apache2.service',
  }
}
