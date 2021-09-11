# Installs and configures an influxdb
class profile::monitoring::influxdb {
  $password = lookup('profile::influx::superuser::password', String)
  $statuspass = lookup('profile::influx::serverstatus::password', String)
  $telegrafpw = lookup('profile::influx::telegraf::password', String)

  class{'influxdb':
    auth_enabled   => true,
    auth_superuser => 'superuser',
    auth_superpass => $password,
  }

  influx_database { 'serverstatus' :
    ensure    => present,
    superuser => 'superuser',
    superpass => $password,
  }

  influx_user { 'homer':
    ensure    => present,
    database  => 'serverstatus',
    password  => $statuspass,
    superuser => 'superuser',
    superpass => $password,
  }

  influx_user { 'telegraf':
    ensure    => present,
    admin     => true,
    password  => $telegrafpw,
    superuser => 'superuser',
    superpass => $password,
  }
}
