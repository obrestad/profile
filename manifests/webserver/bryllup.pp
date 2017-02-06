# Installs our wedding page!
class profile::webserver::bryllup {
  # Database settings
  $mysql_name = hiera('profile::wedding::db::name')
  $mysql_host = hiera('profile::wedding::db::host')
  $mysql_user = hiera('profile::wedding::db::user')
  $mysql_pass = hiera('profile::wedding::db::pass')

  # Django settings
  $django_secret = hiera('profile::wedding::django::secret')
  $configfile = '/etc/wedding/settings.ini'

  # URL's
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

  mysql::db { $mysql_name:
    user           => $mysql_user,
    password       => $mysql_pass,
    host           => $mysql_host,
    grant          => ['CREATE', 'ALTER',
                        'DELETE', 'INSERT',
                        'SELECT', 'UPDATE',
                        'INDEX', 'DROP',
                      ],
    require        => Class['::mysql::server'],
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
                      Mysql::Db[$mysql_name],
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

  file { '/etc/wedding':
    ensure  => directory,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
  }

  ini_setting { 'Wedding debug':
    ensure  => present,
    path    => $configfile,
    section => 'general',
    setting => 'debug',
    value   => false,
    require => [
              Vcsrepo['/opt/wedding'],
              File['/etc/wedding'],
            ],
  }

  ini_setting { 'Wedding django secret':
    ensure  => present,
    path    => $configfile,
    section => 'general',
    setting => 'secret',
    value   => $django_secret,
    require => [
              Vcsrepo['/opt/wedding'],
              File['/etc/wedding'],
            ],
  }

  ini_setting { 'Wedding db type':
    ensure  => present,
    path    => $configfile,
    section => 'database',
    setting => 'type',
    value   => 'mysql',
    require => [
              Vcsrepo['/opt/wedding'],
              File['/etc/wedding'],
            ],
  }

  ini_setting { 'Wedding db host':
    ensure  => present,
    path    => $configfile,
    section => 'database',
    setting => 'host',
    value   => $mysql_host,
    require => [
              Vcsrepo['/opt/wedding'],
              File['/etc/wedding'],
            ],
  }

  ini_setting { 'Wedding db name':
    ensure  => present,
    path    => $configfile,
    section => 'database',
    setting => 'name',
    value   => $mysql_name,
    require => [
              Vcsrepo['/opt/wedding'],
              File['/etc/wedding'],
            ],
  }

  ini_setting { 'Wedding db user':
    ensure  => present,
    path    => $configfile,
    section => 'database',
    setting => 'user',
    value   => $mysql_user,
    require => [
              Vcsrepo['/opt/wedding'],
              File['/etc/wedding'],
            ],
  }

  ini_setting { 'Wedding db password':
    ensure  => present,
    path    => $configfile,
    section => 'database',
    setting => 'password',
    value   => $mysql_pass,
    require => [
              Vcsrepo['/opt/wedding'],
              File['/etc/wedding'],
            ],
  }

  ini_setting { 'Wedding main host':
    ensure  => present,
    path    => $configfile,
    section => 'hosts',
    setting => 'main',
    value   => $url,
    require => [
              Vcsrepo['/opt/wedding'],
              File['/etc/wedding'],
            ],
  }

  ini_setting { 'Wedding staticpath':
    ensure  => present,
    path    => $configfile,
    section => 'general',
    setting => 'staticpath',
    value   => '/opt/weddingstatic',
    require => [
              Vcsrepo['/opt/wedding'],
              File['/etc/wedding'],
            ],
    before  => Exec['/opt/wedding/manage.py collectstatic --noinput'],
  }
}
