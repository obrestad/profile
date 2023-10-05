# Retrieves letsencrypt certs for shiftleader
class profile::shiftleader::cert {
  $api = lookup('shiftleader::params::api_name', String)
  $web = lookup('shiftleader::params::web_name', String)

  ::profile::letsencrypt::certificate { 'Shiftleader':
    domains              => [ $api, $web ],
    cron_success_command => '/bin/systemctl reload apache2.service',
  }
}
