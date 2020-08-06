# Configures default users/groups
class profile::users {
  require ::profile::users::groups
  include ::profile::users::root

  $users = hiera('profile::users', {
    'default_value' => {},
    'merge'         => 'deep',
  })

  $users.map | $username, $data | {
    user { $username:
      ensure     => $data['ensure'],
      gid        => $data['gid'],
      uid        => $data['uid'],
      groups     => $data['groups'],
      shell      => '/bin/bash',
      home       => "/home/${username}",
      managehome => true,
      password   => $data['password'],
    }

    file { "/home/${username}/.bashrc":
      owner   => $username,
      group   => $data['gid'],
      mode    => '0440',
      source  => 'puppet:///modules/profile/userpref/bashrc',
      require => User[$username],
    }
    file { "/home/${username}/.vimrc":
      owner   => $username,
      group   => $data['gid'],
      mode    => '0440',
      source  => 'puppet:///modules/profile/userpref/vimrc',
      require => User[$username],
    }
    file { "/home/${username}/.ssh":
      ensure  => 'directory',
      owner   => $username,
      group   => $data['gid'],
      mode    => '0700',
      require => User[$username],
    }

    $data['sshkeys'].map | $keyname $sshkey | {
      ssh_authorized_key { $keyname:
        user    => $username,
        type    => $sshkey['type'],
        key     => $sshkey['key'],
        require => File["/home/${username}/.ssh"],
      }
    }
  }
}
