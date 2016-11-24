# Create a user for eigil
class profile::users::eigil {
  user { 'eigil':
    ensure      => present,
    gid         => 'users',
    require     => Group['users'],
    groups      => ['admins'],
    uid         => 801,
    shell       => '/bin/bash',
    home        => '/home/eigil',
    managehome  => true,
    password    => hiera('profile::user::eigil::hash'),
  }

  file { '/home/eigil/.bashrc':
    owner   => 'eigil',
    group   => 'users',
    mode    => '0440',
    source  => 'puppet:///modules/profile/userpref/bashrc',
  }
  file { '/home/eigil/.vimrc':
    owner   => 'eigil',
    group   => 'users',
    mode    => '0440',
    source  => 'puppet:///modules/profile/userpref/vimrc',
  }
  file { '/home/eigil/.ssh':
    ensure  => 'directory',
    owner   => 'eigil',
    group   => 'users',
    mode    => '0700',
    require => User['eigil'],
  }

  file { '/home/eigil/www':
    ensure   => 'directory',
    owner    => 'eigil',
    group    => 'www-data',
    mode     => '2755',
    require  => User['eigil'],
  }

  ssh_authorized_key { 'eigil@mocha':
    user    => 'eigil',
    type    => 'ssh-rsa',
    key     => 'AAAAB3NzaC1yc2EAAAABJQAAAQEAvZKZc91/Ga62TYSdGyDd+nbFwyYUwb23bye2XPOC30K/KsokMCemxxxQ2Y+1XmL8AZ2QvzVwvuN/DFpF9km54v9cZtjuby4VcJRGJzXoCTsXmshGn6JhIGKJ1CdeOU4LFLaDJIchugHk4D77XBmOB/4LPe8OqGEMQdRgRYolYTs708Mv/NHxKu/cp5o0dsRoEObUgaIcG5jfA1WnpRb4fWdX5NL/waOidGjO3GTNYOUH8iY8qZVZiW/QxTLxpIDwFtF9U1Eu6Kl/DPT/+0VaV0+2R7q30ZA5csdUkfdvxliMiu7kcFKI5HrAMcSgkrK/MGUWo5wXMCom7U9MezlC2Q==',
    require => File['/home/eigil/.ssh'],
  }

  ssh_authorized_key { 'eigil@carajillo':
    user    => 'eigil',
    type    => 'ssh-rsa',
    key     =>  'AAAAB3NzaC1yc2EAAAADAQABAAABAQDwe4N6Op3OEDYxe/SeHr58jgq7/Ip7uSDLYuOtJl40/IHVWyCwMfQwFWgIzNM+8Obpu9uRvwp85hF7PHoM5MTNgcPGhlJeFUkHbiUu3fhlj4k+YmiW9NpotNbVbTw0s3m2PLVruEvVm8fQ376XTJO2jTOfx7DC25dV+UqAe7XtmZra6l2wEZPr2UN5W7TGr3Th19dkBiQBQMxIGFd/toKOniFdq/+JBp6OH+ZMQ8QIgKkAQ/AKCxYROkxYvWblvOtjk0kehaJkn3b6wjgyMf80yxLvOd4jaX7LO/G8kXjXQ+1gwVImvG0Cw4yG5D20Y+UspwahXeRV5Ik72qsF3ezX',
    require => File['/home/eigil/.ssh'],
  }

  ssh_authorized_key { 'eigil@ristretto':
    user    => 'eigil',
    type    => 'ssh-rsa',
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCeqaOcZY9UWzQVTb+g9aArTP/VCdhdc3jfekbCPWsEaZMiSMEcKGkmnvzHqj9D4VeiqiKWYMJOkM1/KzK+6eh+HgChIR3D2iiM2K3jR060xWzD33hPMzR/d6aF2Iy+ZVaQG+m3rcAMzjBdWqDMechkKyGyc6/rmI/lQwtVfeDqUSYMbsRQ2Lr9uNLCvW0o91rcr46NlD5a/kSRNCydNbOcA19eAnOSxWohDZ45U8iy2lem+6C7Uy80Hs4N0F3Brrn8we8yw7gWeS+W1ElsFV8KpznFQF33phMdkH2H9UzaaWMQo2CIlMf57vsYZzUfbvJDmGszCQrc0BUQ2WPhsgfh',
    require => File['/home/eigil/.ssh'],
  }
}
