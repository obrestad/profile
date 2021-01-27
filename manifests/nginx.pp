# Installs and configures nginx
class profile::nginx {
  include ::nginx

  profile::firewall::generic { 'HTTP':
    protocol => 'tcp',
    port     => [80, 443],
  }
  
  file { '/etc/nginx/conf.d/default.conf': 
    ensure => absent,
    notify => Service['nginx'],
  }
}
