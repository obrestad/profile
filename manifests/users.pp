# Configures default users/groups
class profile::users {
  require ::profile::users::groups
  include ::profile::users::root

  $users = hiera('profile::users', {
    'default_value' => {},
    'merge'         => 'deep',
  })

  $users.map | $username, $data | {
    $group = pick($data['gid'], 'users')

    user { $username:
      ensure         => $data['ensure'],
      gid            => $group,
      groups         => pick($data['groups'], []),
      home           => pick($data['home'], "/home/${username}"),
      managehome     => true,
      password       => pick($data['password'], '*'),
      purge_ssh_keys => true,
      shell          => pick($data['shell'], '/bin/bash'),
      uid            => $data['uid'],
    }

    file { "/home/${username}/.bashrc":
      owner   => $username,
      group   => $group,
      mode    => '0440',
      source  => 'puppet:///modules/profile/userpref/bashrc',
      require => User[$username],
    }
    file { "/home/${username}/.vimrc":
      owner   => $username,
      group   => $group,
      mode    => '0440',
      source  => 'puppet:///modules/profile/userpref/vimrc',
      require => User[$username],
    }
    file { "/home/${username}/.ssh":
      ensure  => 'directory',
      owner   => $username,
      group   => $group,
      mode    => '0700',
      require => User[$username],
    }

    $sshkeys = pick($data['sshkeys'], {})
    $sshkeys.map | $keyname, $sshkey | {
      ssh_authorized_key { $keyname:
        user    => $username,
        type    => $sshkey['type'],
        key     => $sshkey['key'],
        require => File["/home/${username}/.ssh"],
      }
    }
  }
}
