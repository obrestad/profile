# Configures generic firewall-rules
class profile::firewall {
  $purge = lookup('profile::firewall::purge', {
    'value_type'    => Boolean,
    'default_value' => true,
  })

  Firewall {
    before  => Class['::profile::firewall::post'],
    require => Class['::profile::firewall::pre'],
  }
  
  include ::profile::firewall::pre
  include ::profile::firewall::post

  if($purge) {
    resources { 'firewall':
      purge => true,
    }
  }
  
  include ::firewall
}
