# Installs amavis and related tools 
class profile::mailserver::amavis::install {
  package { 'amavisd-new':
    ensure => 'present',
  }
}
