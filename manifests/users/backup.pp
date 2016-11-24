# Create a user which can be used for backups
class profile::users::backup {
  user { 'remote-backup':
    ensure      => present,
    require     => Group['service'],
    gid         => 'service',
    uid         => 800,
    shell       => '/bin/bash',
    home        => '/home/remote-backup',
    managehome  => true,
    password    => '*',
  }

  file { '/home/remote-backup/.ssh':
    ensure   => 'directory',
    owner    => 'remote-backup',
    group    => 'service',
    mode     => '0700',
    require  => User['remote-backup'],
  }

  ssh_authorized_key { 'root@antoccino':
    user    => 'remote-backup',
    type    => 'ssh-rsa',
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC/OdpRVK/mISztiaxquAz1R8O/eR4r30vU77QmERzQyNM4Kx90QWYR91vQZ3gm0cb3DtHeqvRL6xBROTGY1OeTBOd4GZYBQ2VOVSTdQoxmnxl8nKkx7B4eAryXoXAbuWOWqHIoAxow5RbopzO3HJ+rCPAS5n2m6AJleUAVpEwN8uqg4iyEOZa/aT4QvSm6qahzNG+k7eX3i0qarm4Jc6GoJLBP17lt0lLf4/ortXD9yoni66jtS/dXUXacFVHJQfolCfO30W3R9+yYY93n8GHRx/J8LNB/If6e5xBxt3FHxXgyMO7hnwPm0Chn3kC5tXN25aPow+a5w+s2Lk7VMue3',
    require => File['/home/remote-backup/.ssh'],
  }
  ssh_authorized_key { 'root@frappuccino':
    user    => 'remote-backup',
    type    => 'ssh-rsa',
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDMLO39rOuIs20ndBn/nGFjYlYIj1RVyYr/UJMAVUSMbAT1iFkWZ/CL2GLHTw/mIGJuqFJFYVgzMX8Q/RXT9qAXqKBmc7yed2IEh18qC4Q3Gz0DkUf9znL4PFo+UjQ6+QSf2pXG3Sj7Fm44hI+2/2cb6IEP/8UhSy8287WAQrgGiocoqPmCwiy/MGVwMF41oCd6tQU5LoqRka2MWSNBo01wSIIjhHRejp6FxMfz79JEl/eddHGL/8A0PtZrBS/WIoIPorKuhVXZVV9NpxXdGMlKONBndKd67OvM+zV0RmuNSNqqGC5v6TWLjeuTJIaIy7Mo32XHR+E+JwqLHMbExZn3',
    require => File['/home/remote-backup/.ssh'],
  }
  ssh_authorized_key { 'b-eigil@carajillo':
    user    => 'remote-backup',
    type    => 'ssh-rsa',
    key     =>  'AAAAB3NzaC1yc2EAAAADAQABAAABAQDwe4N6Op3OEDYxe/SeHr58jgq7/Ip7uSDLYuOtJl40/IHVWyCwMfQwFWgIzNM+8Obpu9uRvwp85hF7PHoM5MTNgcPGhlJeFUkHbiUu3fhlj4k+YmiW9NpotNbVbTw0s3m2PLVruEvVm8fQ376XTJO2jTOfx7DC25dV+UqAe7XtmZra6l2wEZPr2UN5W7TGr3Th19dkBiQBQMxIGFd/toKOniFdq/+JBp6OH+ZMQ8QIgKkAQ/AKCxYROkxYvWblvOtjk0kehaJkn3b6wjgyMf80yxLvOd4jaX7LO/G8kXjXQ+1gwVImvG0Cw4yG5D20Y+UspwahXeRV5Ik72qsF3ezX',
    require => File['/home/remote-backup/.ssh'],
  }
}
