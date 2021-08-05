# This class installs some packages needed for the mailadmin webinterface
class profile::mailadmin::dependencies {
  package { [
      'libjs-jquery',
      'python3-django',
      'python3-mysqldb',
      'python3-passlib',
    ] :
    ensure => present,
  }
}
