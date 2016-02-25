class profile::dlnaserver {
	package { 'minidlna':
		ensure => present,
	}
  
}
