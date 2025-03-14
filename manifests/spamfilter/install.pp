# This class installs the spamfilter
class profile::spamfilter::install {
  package {['spamassassin', 'spamc']:
    ensure => 'present',
  }
}
