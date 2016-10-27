# This class configures the git daemon
class profile::git::daemonconfig {
  ini_setting { 'Enable git-daemon':
    ensure  => present,
    path    => '/etc/default/git-daemon',
    setting => 'GIT_DAEMON_ENABLE',
    value   => 'true',
  }

  ini_setting { 'Set git-daemon user':
    ensure  => present,
    path    => '/etc/default/git-daemon',
    setting => 'GIT_DAEMON_USER',
    value   => 'git',
  }

  ini_setting { 'Set git-daemon path1':
    ensure  => present,
    path    => '/etc/default/git-daemon',
    setting => 'GIT_DAEMON_BASE_PATH',
    value   => '/srv/git/repositories',
  }

  ini_setting { 'Set git-daemon path2':
    ensure  => present,
    path    => '/etc/default/git-daemon',
    setting => 'GIT_DAEMON_DIRECTORY',
    value   => '/srv/git/repositories',
  }
}
