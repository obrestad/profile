class profile::users {
  group { 'users':
    ensure => present,
    gid => 700,
  }
  group { 'admins':
    ensure => present,
    gid => 701,
  }
  group { 'service':
    ensure => present,
    gid => 702,
  }

  file { "/root/.ssh":
    owner    => "root",
    group    => "root",
    mode     => "700",
    ensure   => "directory",
  }
  
  file { "/root/.bashrc":
    owner => "root",
    group => "root",
    mode  => "440",
    source => "puppet:///modules/profile/userpref/bashrc",
  }   
  file { "/root/.vimrc":
    owner => "root",
    group => "root",
    mode  => "440",
    source => "puppet:///modules/profile/userpref/vimrc",
  }
  
  include ::profile::users::eigil
}
