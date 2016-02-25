class profile::dlnaserver {
	package { 'minidlna':
		ensure => present,
	}

	ini_setting { "Media folder":
		ensure  => present,
		path    => '/etc/minidlna.conf',
		setting => 'media_dir',
		value   => '/srv/media',
	}	
	ini_setting { "DbDir":
		ensure  => present,
		path    => '/etc/minidlna.conf',
		setting => 'db_dir',
		value   => '/var/cache/minidlna',
	}	
	ini_setting { "LogDir":
		ensure  => present,
		path    => '/etc/minidlna.conf',
		setting => 'log_dir',
		value   => '/var/log',
	}	
	ini_setting { "NetIF":
		ensure  => present,
		path    => '/etc/minidlna.conf',
		setting => 'network_interface',
		value   => 'eth0',
	}	
	ini_setting { "friendly_name":
		ensure  => present,
		path    => '/etc/minidlna.conf',
		setting => 'friendly_name',
		value   => 'Mediaserveren',
	}	
	ini_setting { "inotify":
		ensure  => present,
		path    => '/etc/minidlna.conf',
		setting => 'inotify',
		value   => 'yes',
	}	
}
