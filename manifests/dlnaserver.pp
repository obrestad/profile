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
}
