# Configures an nginx reverse proxy, and issuing a certificate for it.
define profile::nginx::proxy (
  $target,
  $alias = [],
){
  include ::profile::nginx

  $certdir = $::facts['letsencrypt_directory'][$name]

  if($certdir) {
    $sslconf = {
      'ssl'          => true,
      'ssl_cert'     => "${certdir}/fullchain.pem",
      'ssl_key'      => "${certdir}/privkey.pem",
      'ssl_port'     => 443,
      'ssl_redirect' => true,
      'require'      => Profile::Letsencrypt::Certificate["nginxproxy-${name}"],
    }
  } else {
    $sslconf = {}
  }

  nginx::resource::server { $name:
    listen_port => 80,
    proxy       => $target,
    server_name => [ $name ] + $alias,
    *           => $sslconf
  }

  profile::letsencrypt::certificate { "nginxproxy-${name}":
    domains              => [ $name ] + $alias,
    manage_cron          => true,
    cron_success_command => '/bin/systemctl reload nginx.service',
  }
}
