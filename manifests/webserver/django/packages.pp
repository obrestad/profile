# This class installs some packages needed for django
class profile::webserver::django::packages {
  package { [
      'python3-django',
      'python3-mysqldb',
      'python3-passlib',
    ] :
    ensure => present,
  }
}
