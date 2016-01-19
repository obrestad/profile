class profile::firewall {
  Firewall {
    before  => Class['::profile::firewall::post'],
    require => Class['::profile::firewall::pre'],
  }
  
  include ::profile::firewall::pre
  include ::profile::firewall::post
  
  include ::firewall
}
