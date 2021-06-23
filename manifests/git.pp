# This class installs gitolite to allow for hosting git repos with access
# control.
class profile::git {
  $admin_key = hiera('profile::gitolite::admin-key')

  include ::profile::git::backup
  include ::profile::git::firewall

  package{ 'gitolite3':
    ensure => present,
  }

  package{ 'git-daemon-sysvinit':
    ensure => present,
  }

  class {'::profile::git::daemonconfig':
    require => Package['git-daemon-sysvinit'],
  }

  service { 'git-daemon':
    ensure  => 'running',
    require => Class['::profile::git::daemonconfig'],
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
}
