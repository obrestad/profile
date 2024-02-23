# Installs a couple of dependencies for letsencrypt
class profile::letsencrypt::dependencies {
  require ::profile::utilities::pip3

  package { 'python3-openssl':
    ensure => 'present',
  }
}
