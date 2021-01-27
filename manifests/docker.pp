# Installs and configures docker 
class profile::docker {
  $users = lookup('profile::docker::users', {
    'value_type'    => Array[String],
    'default_value' => [],
  })

  include ::profile::docker::ingress

  class { 'docker':
    ensure       => present,
    docker_users => $users,
    version      => 'latest',
  }

  class {'docker::compose':
    ensure => present,
  }
}
