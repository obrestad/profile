# Installs python-pip so others can use it as a package provider. 
class profile::utilities::pip3 {
  package{ 'python3-pip':
    ensure => present,
  }
}
