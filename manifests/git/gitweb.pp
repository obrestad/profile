# This class installs gitweb.
class profile::git::gitweb {
  $gitwebname = hiera('profile::git::gitweb')

  package{ 'gitweb':
    ensure => present,
  }

  package{ 'libcgi-pm-perl':
    ensure => present,
  }

  apache::vhost { "${gitwebname} http":
    servername    => $gitwebname,
    port          => '80',
    docroot       => '/srv/git/repositories/',
    docroot_owner => 'git',
    docroot_group => 'service',
    setenv        => ['GITWEB_CONFIG /srv/git/gitweb.conf'],
    directories   => [
      { path           => '/srv/git/repositories/',
        options        => ['Indexes', 'FollowSymlinks', 'ExecCGI'],
        allow_override => ['None'],
        require        => 'all granted',
        directoryindex => '/cgi-bin/gitweb.cgi',
        rewrites       => [
          { rewrite_rule => [ '^/$  /cgi-bin/gitweb.cgi' ]
          },
          { rewrite_rule => [ '^/(.*\.git/(?!/?(HEAD|info|objects|refs)).*)?$ /cgi-bin/gitweb.cgi%{REQUEST_URI}  [L,PT]' ]
          },
        ],
      },
    ],
    aliases => [
      { alias            => '/static/',
        path             => '/usr/share/gitweb/static/',
      },
      { scriptalias      => '/cgi-bin/',
        path             => '/usr/share/gitweb/',
      },
    ],
  }
}
