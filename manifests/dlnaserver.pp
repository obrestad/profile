class profile::dlnaserver {
	package { 'minidlna':
		ensure => present,
	}
	
	service { 'minidlna':
		ensure => running,
	}

	ini_setting { "Media folder":
		ensure  => present,
		path    => '/etc/minidlna.conf',
		setting => 'media_dir',
		value   => '/srv/media',
		notify => Service['minidlna'],
	}	
	ini_setting { "DbDir":
		ensure  => present,
		path    => '/etc/minidlna.conf',
		setting => 'db_dir',
		value   => '/var/cache/minidlna',
		notify => Service['minidlna'],
	}	
	ini_setting { "LogDir":
		ensure  => present,
		path    => '/etc/minidlna.conf',
		setting => 'log_dir',
		value   => '/var/log',
		notify => Service['minidlna'],
	}	
	ini_setting { "NetIF":
		ensure  => present,
		path    => '/etc/minidlna.conf',
		setting => 'network_interface',
		value   => 'eth0',
		notify => Service['minidlna'],
	}	
	ini_setting { "friendly_name":
		ensure  => present,
		path    => '/etc/minidlna.conf',
		setting => 'friendly_name',
		value   => 'Mediaserveren',
		notify => Service['minidlna'],
	}	
	ini_setting { "inotify":
		ensure  => present,
		path    => '/etc/minidlna.conf',
		setting => 'inotify',
		value   => 'yes',
		notify => Service['minidlna'],
	}	

  firewall { '100 accept incoming DLNA':
    proto  => 'tcp',
	dport  => 8200,
    action => 'accept',
  }
  firewall { '101 accept incoming DLNA':
    proto  => 'udp',
	dport  => 55806,
    action => 'accept',
  }
  firewall { '102 accept incoming DLNA':
    proto  => 'udp',
	dport  => 1900,
    action => 'accept',
  }
}
