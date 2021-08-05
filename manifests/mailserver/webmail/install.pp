# Installs required packages for the webmail
class profile::mailserver::webmail::install {
  package { [
    'roundcube',
    'roundcube-core',
    'roundcube-mysql',
    'roundcube-plugins'
  ] :
    ensure => 'present',
  }
}
