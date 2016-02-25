class profile::users::backup {
  user { 'remote-backup':
    ensure      => present,
    gid         => 800,
    uid         => Group['service'],
    shell       => '/bin/bash',
    home        => '/home/remote-backup',
    managehome  => true,
    password    => "*",
  }
  
  file { "/home/remote-backup/.ssh":
    owner    => "backup",
    group    => "service",
    mode     => "700",
    ensure   => "directory",
    require  => User['remote-backup'],
  }
}
