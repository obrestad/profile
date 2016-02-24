class profile::users::backup {
  user { 'backup':
    ensure      => present,
    gid         => 34,
    uid         => 34,
    shell       => '/usr/sbin/nologin',
    home        => '/var/backups',
    managehome  => true,
    password    => "*",
  }
  
  file { "/var/backups/.ssh":
    owner    => "backup",
    group    => "service",
    mode     => "700",
    ensure   => "directory",
    require  => User['backup'],
  }
}
