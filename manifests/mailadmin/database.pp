# This define configures the database-settings for mailadmin 
class profile::mailadmin::database {
  $dbname = lookup('profile::mailserver::db::name')
  $dbhost = lookup('profile::mailserver::db::host')
  $dbuser = lookup('profile::mailserver::db::user')
  $dbpass = lookup('profile::mailserver::db::pass')

  $configfile = '/etc/mailadmin/settings.ini'

  include ::profile::mailadmin::install

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
    value   => $dbhost,
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
    value   => $dbname,
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
    value   => $dbuser,
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
    value   => $dbpass,
    require => [
              Vcsrepo['/opt/mailadmin'],
              File['/etc/mailadmin'],
            ],
  }
}
