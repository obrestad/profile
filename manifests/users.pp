class profile::users {
  group { 'users':
    ensure => present,
    gid => 700,
  }
  group { 'admins':
    ensure => present,
    gid => 701,
  }

  file { "/root/.ssh":
    owner    => "root",
    group    => "root",
    mode     => 700,
    ensure   => "directory",
  }
  
  include ::profile::users::eigil
}
