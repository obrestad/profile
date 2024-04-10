# Configures the root-user
class profile::users::root {
  file { '/root/.ssh':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file { '/root/.bashrc':
    owner  => 'root',
    group  => 'root',
    mode   => '0440',
    source => 'puppet:///modules/profile/userpref/bashrc',
  }

  file { '/root/.vimrc':
    owner  => 'root',
    group  => 'root',
    mode   => '0440',
    source => 'puppet:///modules/profile/userpref/vimrc',
  }

  $sshkeys = lookup('profile::root:keys', {
    'default_value' => {},
    'value_type'    => Hash,
  })

  $sshkeys.map | $keyname, $sshkey | {
    ssh_authorized_key { $keyname:
      user    => 'root',
      type    => $sshkey['type'],
      key     => $sshkey['key'],
      require => File['/root/.ssh'],
    }
  }
}
