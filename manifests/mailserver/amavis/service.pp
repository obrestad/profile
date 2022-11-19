# Manages the amavis service 
class profile::mailserver::amavis::service {
  service { 'amavisd-new':
    ensure => 'running',
  }
}
