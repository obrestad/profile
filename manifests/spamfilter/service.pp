# This class manages the spamfilter service 
class profile::spamfilter::service {
  service { 'spamassassin':
    ensure => 'running',
    enable => true,
  }
}
