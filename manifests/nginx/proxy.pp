# Configures an nginx reverse proxy, and issuing a certificate for it.
define profile::nginx::proxy (
  $target,
  $alias = [],
){
  include ::nginx

  $certdir = $::facter['letsencrypt_directory']["nginxproxy-${name}"]

  nginx::resource::server { $name:
    listen_port => 80,
    proxy       => $target,
    server_name => [ $name ] + $alias,
    ssl         => true,
    ssl_cert    => "${certdir}/fullchain.pem",
    ssl_key     => "${certdir}/privkey.pem",
    ssl_port    => 443,
    require     => Profile::Letsencrypt::Certificate["nginxproxy-${name}"],
  }

  profile::letsencrypt::certificate { "nginxproxy-${name}":
    domains => [ $name ] + $alias,
  }
}
