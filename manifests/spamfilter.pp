# This class installs and configures the spamfilter
class profile::spamfilter {
  include profile::spamfilter::config
  include profile::spamfilter::install
  include profile::spamfilter::service

  Class['::profile::spamfilter::install'] 
  -> Class['::profile::spamfilter::config']
 
  Class['::profile::spamfilter::config']
  ~> Service['spamassassin']
}
