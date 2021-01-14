# Installs and configures docker 
class profile::docker {
  class { 'docker':
    ensure  => present,
    version => 'latest',
  }

  class {'docker::compose':
    ensure => present,
  }
}
