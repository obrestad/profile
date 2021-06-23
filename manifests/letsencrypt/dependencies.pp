# Installs a couple of dependencies for letsencrypt
class profile::letsencrypt::dependencies {
  package { [
    'python3-openssl',
    'python3-cryptography',
  ]:
    ensure => 'present',
  }
}
