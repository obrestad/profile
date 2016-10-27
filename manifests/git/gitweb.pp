# This class installs gitweb.
class profile::git::gitweb {
  package{ 'gitweb':
    ensure => present,
  }
}
