# Configures the webserver used by the webmail-client, and requests SSL
# certificates. It also installs the mailadmin webinterface.
class profile::mailserver::web {
  $mailname = hiera('profile::mail::hostname')
  $webmailname = hiera('profile::mail::webmail')
  $mysql_name = hiera('profile::mail::db::name')
  $mysql_host = hiera('profile::mail::db::host')
  $mysql_user = hiera('profile::mail::db::user')
  $mysql_pass = hiera('profile::mail::db::pass')
  $django_secret = hiera('profile::mail::django::secret')

  $configfile = '/etc/mailadmin/settings.ini'
  $location = '/usr/lib/python3/dist-packages'

  apache::vhost { "${mailname} http":
    servername                  => $mailname,
    port                        => '80',
    docroot                     => "${location}/mailadmin/",
    docroot_owner               => 'www-data',
    docroot_group               => 'www-data',
    directories                 => [
      { path     => "${location}/mailadmin/",
        require  => 'all granted',
      },
      { path     => '/opt/mailadminstatic/',
        require  => 'all granted',
      },
    ],
    custom_fragment             => "
  <Directory ${location}/mailadmin/mailadmin>
    <Files wsgi.py>
      Require all granted
    </Files>
  </Directory>",
    wsgi_script_aliases         => {
      '/' => "${location}/mailadmin/mailadmin/wsgi.py"
    },
    wsgi_daemon_process         => 'mailadmin',
    wsgi_daemon_process_options =>
    { processes    => '2',
      threads      => '15',
      display-name => '%{GROUP}',
    },
    wsgi_process_group          => 'mailadmin',
    aliases                     => [
      { alias   => '/static/',
        path    => "${location}/mailadminstatic/",
      },
    ],
  }
  apache::vhost { "${mailname} https":
    servername                  => $mailname,
    port                        => '443',
    docroot                     => "${location}/mailadmin/",
    ssl                         => true,
    ssl_cert                    =>
        "/etc/letsencrypt/live/${mailname}/fullchain.pem",
    ssl_key                     =>
        "/etc/letsencrypt/live/${mailname}/privkey.pem",
    require                     =>
        Letsencrypt::Certonly["${mailname}-${::fqdn}"],
    directories                 => [
      { path     => "${location}/mailadmin/",
        require  => 'all granted',
      },
      { path     => '/opt/mailadminstatic/',
        require  => 'all granted',
      },
    ],
    custom_fragment             => "
  <Directory ${location}/mailadmin/mailadmin>
    <Files wsgi.py>
      Require all granted
    </Files>
  </Directory>",
    wsgi_script_aliases         => {
      '/' => "${location}/mailadmin/mailadmin/wsgi.py"
    },
    wsgi_daemon_process         => 'mailadmin-ssl',
    wsgi_daemon_process_options =>
    { processes    => '2',
      threads      => '15',
      display-name => '%{GROUP}',
    },
    wsgi_process_group          => 'mailadmin-ssl',
    aliases                     => [
      { alias   => '/static/',
        path    => "${location}/mailadminstatic/",
      },
    ],
  }

  letsencrypt::certonly { "${mailname}-${::fqdn}":
    domains       => [$mailname, $::fqdn],
    plugin        => 'webroot',
    webroot_paths => ["/var/www/${mailname}", "/var/www/${::fqdn}"],
    require       => Apache::Vhost["${mailname} http"],
    manage_cron   => true,
  }
  package { [
      'python3-django',
      'python3-mysqldb',
      'python3-passlib',
    ] :
    ensure => present,
    before => Exec["${location}/mailadmin/manage.py syncdb --noinput"],
  }

  vcsrepo { "${location}/mailadmin":
    ensure    => latest,
    provider  => git,
    source    => 'git://git.rothaugane.com/mailadmin.git',
    revision  => 'master',
    notify    => [
                Exec["${location}/mailadmin/manage.py syncdb --noinput"],
                Exec["${location}/mailadmin/manage.py collectstatic --noinput"],
              ],
  }

  exec { "${location}/mailadmin/manage.py syncdb --noinput":
    refreshonly   => true,
    require       => [
                      Vcsrepo["${location}/mailadmin"],
                      Mysql::Db[$mysql_name],
                  ],
  }

  file { '/opt/mailadminstatic':
    ensure  => directory,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
  }

  exec { "${location}/mailadmin/manage.py collectstatic --noinput":
    refreshonly   => true,
    require       => [
                      Vcsrepo["${location}/mailadmin"],
                      File['/opt/mailadminstatic'],
                  ],
  }

  file { '/etc/mailadmin':
    ensure  => directory,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
  }

  ini_setting { 'Mailadmin debug':
    ensure  => present,
    path    => $configfile,
    section => 'general',
    setting => 'debug',
    value   => false,
    require => [
              Vcsrepo['/opt/mailadmin'],
              File['/etc/mailadmin'],
            ],
  }

  ini_setting { 'Mailadmin django secret':
    ensure  => present,
    path    => $configfile,
    section => 'general',
    setting => 'secret',
    value   => $django_secret,
    require => [
              Vcsrepo['/opt/mailadmin'],
              File['/etc/mailadmin'],
            ],
  }

  ini_setting { 'Mailadmin db type':
    ensure  => present,
    path    => $configfile,
    section => 'database',
    setting => 'type',
    value   => 'mysql',
    require => [
              Vcsrepo['/opt/mailadmin'],
              File['/etc/mailadmin'],
            ],
  }

  ini_setting { 'Mailadmin db host':
    ensure  => present,
    path    => $configfile,
    section => 'database',
    setting => 'host',
    value   => $mysql_host,
    require => [
              Vcsrepo['/opt/mailadmin'],
              File['/etc/mailadmin'],
            ],
  }

  ini_setting { 'Mailadmin db name':
    ensure  => present,
    path    => $configfile,
    section => 'database',
    setting => 'name',
    value   => $mysql_name,
    require => [
              Vcsrepo['/opt/mailadmin'],
              File['/etc/mailadmin'],
            ],
  }

  ini_setting { 'Mailadmin db user':
    ensure  => present,
    path    => $configfile,
    section => 'database',
    setting => 'user',
    value   => $mysql_user,
    require => [
              Vcsrepo['/opt/mailadmin'],
              File['/etc/mailadmin'],
            ],
  }

  ini_setting { 'Mailadmin db password':
    ensure  => present,
    path    => $configfile,
    section => 'database',
    setting => 'password',
    value   => $mysql_pass,
    require => [
              Vcsrepo['/opt/mailadmin'],
              File['/etc/mailadmin'],
            ],
  }

  ini_setting { 'Mailadmin main host':
    ensure  => present,
    path    => $configfile,
    section => 'hosts',
    setting => 'main',
    value   => $mailname,
    require => [
              Vcsrepo['/opt/mailadmin'],
              File['/etc/mailadmin'],
            ],
  }

  ini_setting { 'Mailadmin staticpath':
    ensure  => present,
    path    => $configfile,
    section => 'general',
    setting => 'staticpath',
    value   => '/opt/mailadminstatic',
    require => [
              Vcsrepo['/opt/mailadmin'],
              File['/etc/mailadmin'],
            ],
    before  => Exec['/opt/mailadmin/manage.py collectstatic --noinput'],
  }
}
