class profile::firewall {
  resources { 'firewall':
    purge => true,
  }
  
  resources { 'firewallchain':
    purge => true,
  }
  
  Firewall {
    before  => Class['::profile::firewall::post'],
    require => Class['::profile::firewall::pre'],
  }
  
  include ::profile::firewall::pre
  include ::profile::firewall::post
  
  include ::firewall
}
