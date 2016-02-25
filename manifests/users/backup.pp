class profile::users::backup {
  user { 'remote-backup':
    ensure      => present,
    require     => Group['service'],
    gid         => 'service',
    uid         => 800,
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

  ssh_authorized_key { "root@antoccino":
    user => "remote-backup",
    type => 'ssh-rsa',
    key => 	'AAAAB3NzaC1yc2EAAAADAQABAAABAQC/OdpRVK/mISztiaxquAz1R8O/eR4r30vU77QmERzQyNM4Kx90QWYR91vQZ3gm0cb3DtHeqvRL6xBROTGY1OeTBOd4GZYBQ2VOVSTdQoxmnxl8nKkx7B4eAryXoXAbuWOWqHIoAxow5RbopzO3HJ+rCPAS5n2m6AJleUAVpEwN8uqg4iyEOZa/aT4QvSm6qahzNG+k7eX3i0qarm4Jc6GoJLBP17lt0lLf4/ortXD9yoni66jtS/dXUXacFVHJQfolCfO30W3R9+yYY93n8GHRx/J8LNB/If6e5xBxt3FHxXgyMO7hnwPm0Chn3kC5tXN25aPow+a5w+s2Lk7VMue3',
    require => File['/home/remote-backup/.ssh'], 
  }
}
