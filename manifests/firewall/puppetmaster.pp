class profile::firewall::puppetmaster {
  firewall { '005 accept incoming puppetmaster':
    proto  => 'tcp',
	dport  => 8140,
    action => 'accept',
  }
}
