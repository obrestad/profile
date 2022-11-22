# This class installs the spamfilter
class profile::spamfilter::install {
  package {['spamassassin', 'spamc']:
    ensure => 'present',
  }

  # Install BIND for DNS BL's.
  package { 'bind9': 
    ensure => 'present',
  }
}
