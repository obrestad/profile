# Installs the munin master node
class profile::munin::master {
  $munin_url = hiera('profile::munin::url')

  class{ '::munin::master':
  }

  apache::vhost { "${munin_url} http":
    servername    => $munin_url,
    serveraliases => [$munin_url],
    port          => '80',
    docroot       => '/var/cache/munin/www',
    docroot_owner => 'www-data',
    docroot_group => 'www-data',
    directories   => [
      { path            => '/munin-cgi/munin-cgi-graph',
        provider        => 'location',
        require         => 'local',
        custom_fragment => '
      <IfModule mod_fcgid.c>
        SetHandler fcgid-script
      </IfModule>
      <IfModule !mod_fcgid.c>
        SetHandler cgi-script
      </IfModule>',
      },
      { path    => '/var/cache/munin/www',
        require => 'local',
        options => ['None'],
      },
    ],
    aliases       => [
      { scriptalias => '/munin-cgi/munin-cgi-graph',
        path        => '/usr/lib/munin/cgi/munin-cgi-graph',
      },
    ],
  }
}
