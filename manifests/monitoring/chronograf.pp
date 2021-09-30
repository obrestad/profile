#Installs and configures chronograf
class profile::monitoring::chronograf {
  $influxpass = lookup('profile::influx::telegraf::password', String)

  class { 'chronograf':
    manage_repo     => false,
  }
  
  chronograf::connection::influx { 'Influx':
    ensure               => 'present',
    id                   => '10000',
    username             => 'telegraf',
    password             => $influxpass, 
    url                  => 'http://localhost:8086',
    type                 => 'influx',
    insecure_skip_verify => false,
    default              => true,
    telegraf             => 'telegraf',
    organization         => 'rothaugane',
  }

  profile::nginx::proxy { $::fqdn:
    target => 'http://localhost:8888',
  }
}
