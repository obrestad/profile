# Installs and configures an influxdb
class profile::monitoring::influxdb {
  $password = lookup('profile::influx::superuser::password', String)
  $statuspass = lookup('profile::influx::serverstatus::password', String)
  $telegrafpw = lookup('profile::influx::telegraf::password', String)

  class{'influxdb':
    admin_enable      => true,
    admin_username    => 'superuser',
    admin_password    => $password,
    http_auth_enabled => false,
  }

  influxdb::database { 'serverstatus' :
  }
  influxdb::user { 'serverstatus':
    passwd => $statuspass,
  }
  influxdb::privilege { 'serverstatus' :
    db_name => 'serverstatus',
    db_user => 'serverstatus',
  }

  influxdb::user { 'telegraf':
    ensure   => present,
    is_admin => true,
    passwd   => $telegrafpw,
  }

  ::profile::firewall::generic { 'influx':
    protocol => 'tcp',
    port     => 8086,
  }
}
