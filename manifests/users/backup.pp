class profile::users::eigil {
  user { 'backup':
    ensure      => present,
    gid         => 'service',
    require     => Group['service'],
    uid         => 501,
    shell       => '/bin/bash',
    home        => '/home/backup',
    managehome  => true,
    password    => "*",
  }
  
  file { "/home/backup/.ssh":
    owner    => "backup",
    group    => "service",
    mode     => "700",
    ensure   => "directory",
    require  => User['backup'],
  }
}
