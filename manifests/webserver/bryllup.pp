# Installs our wedding page!
class profile::webserver::bryllup {
  $url = hiera('profile::bryllup::url')
  $url_alt = hiera('profile::bryllup::url_alt')

  apache::vhost { "${url_alt} http":
    servername      => $url_alt,
    port            => '80',
    docroot         => "/var/www/${url_alt}",
    redirect_source => ['/'],
    redirect_dest   => ["http://${url}/"],
    redirect_status => ['permanent'],
  }
  apache::vhost { "${url} http":
    servername          => $url,
    port                => '80',
    docroot             => "/var/www/${url}",
    directories         => [
      { path    => '/opt/weedingstatic/',
        require => 'all granted',
      },
    ],
    custom_fragment     => '
  <Directory /opt/wedding/wedding>
    <Files wsgi.py>
      Require all granted
    </Files>
  </Directory>',
    wsgi_script_aliases => { '/' => '/opt/wedding/wedding/wsgi.py' },
    aliases             => [
      { alias => '/static/',
        path  => '/opt/weddingstatic/',
      },
    ],
  }

  vcsrepo { '/opt/wedding':
    ensure    => latest,
    provider  => git,
    source    => 'git://git.rothaugane.com/wedding.git',
    revision  => 'master',
    notify    => [
                  Exec['/opt/wedding/manage.py syncdb --noinput'],
                  Exec['/opt/wedding/manage.py collectstatic --noinput'],
                  Service['httpd'],
              ],
  }

  exec { '/opt/wedding/manage.py syncdb --noinput':
    refreshonly   => true,
    require       => [
                      Vcsrepo['/opt/wedding'],
                  ],
  }

  file { '/opt/weddingstatic':
    ensure  => directory,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
  }

  exec { '/opt/wedding/manage.py collectstatic --noinput':
    refreshonly   => true,
    require       => [
                      Vcsrepo['/opt/wedding'],
                      File['/opt/weddingstatic'],
                  ],
  }
}
