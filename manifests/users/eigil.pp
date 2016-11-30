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

  ssh_authorized_key { 'eigil@win10-hjemme':
    user    => 'eigil',
    type    => 'ssh-rsa',
    key     => 'AAAAB3NzaC1yc2EAAAABJQAAAQEAnwYKX2izaKOxO6k81NzJJnq5QKJtbDgH2xX0pvhEVJfn2I7uNMZ3F0PF8P2F4xk8DES0eGLuTSGPnFI0sSUXzPyMo0Nuh5MESAN4NDqQp35OcUnO9mZL8vwmhlas9ZLyeliMM0Bzh7s6VmufDIzItbV9nnlg79EyVWyQvxdoLLmoPD6rh5lJeWrdkAxMUS4ju6VGCbo9I7dri74bsIuzR0ROu04LidchoEwLXmHcZu0i0e6KwTOY2Jw74h9AHmQ4Qnaieoi0SNGvKYxSnU+G1FJGY2kg/DXortfkE4lekyak9EPoDz2NQpPTrF7zjkJaQI3+XaY30D5cvZA8S8DLIQ',
    require => File['/home/eigil/.ssh'],
  }

  ssh_authorized_key { 'eigil@breve':
    user    => 'eigil',
    type    => 'ssh-rsa',
    key     =>  'AAAAB3NzaC1yc2EAAAADAQABAAABAQDwe4N6Op3OEDYxe/SeHr58jgq7/Ip7uSDLYuOtJl40/IHVWyCwMfQwFWgIzNM+8Obpu9uRvwp85hF7PHoM5MTNgcPGhlJeFUkHbiUu3fhlj4k+YmiW9NpotNbVbTw0s3m2PLVruEvVm8fQ376XTJO2jTOfx7DC25dV+UqAe7XtmZra6l2wEZPr2UN5W7TGr3Th19dkBiQBQMxIGFd/toKOniFdq/+JBp6OH+ZMQ8QIgKkAQ/AKCxYROkxYvWblvOtjk0kehaJkn3b6wjgyMf80yxLvOd4jaX7LO/G8kXjXQ+1gwVImvG0Cw4yG5D20Y+UspwahXeRV5Ik72qsF3ezX',
    require => File['/home/eigil/.ssh'],
  }
}
