# This class installs and configures the spamfilter
class profile::mailserver::spamfilter {
  package {['spamassassin', 'spamc']:
    ensure => 'present',
  }
}
