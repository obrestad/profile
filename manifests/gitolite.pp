# This class installs gitolite to allow for hosting git repos with access
# control.
class profile::gitolite {
  $admin_key = hiera('profile::gitolite::admin-key')

  package{ 'gitolite3':
    ensure => present,
  }

  user { 'git':
    ensure      => present,
    gid         => 'service',
    require     => Group['service'],
    shell       => '/bin/bash',
    home        => '/srv/git',
    managehome  => true,
    system      => true,
  }

  file { '/srv/git/admin_pub_key.pub':
    ensure   => 'file',
    owner    => 'git',
    group    => 'service',
    mode     => '0644',
    require  => User['git'],
    content  => $admin_key,
  }

  exec { 'gitolite setup -pk /srv/git/admin_pub_key.pub':
    environment => 'HOME=/srv/git',
    cwd         => '/srv/git',
    path        => '/usr/bin',
    user        => 'git',
    creates     => '/srv/git/.gitolite.rc',
    require     => File['/srv/git/admin_pub_key.pub'],
  }

  file { '/usr/local/sbin/git-backup':
    owner  => 'root',
    group  => 'root',
    mode   => '0744',
    source => 'puppet:///modules/profile/scripts/git-backup.sh',
  }->
  cron { 'git-backup':
    command => '/usr/local/sbin/git-backup',
    user    => root,
    hour    => [3, 9, 15, 21],
    minute  => [45],
  }
}
