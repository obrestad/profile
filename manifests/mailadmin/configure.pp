# This class configures the mailadmin app. 
class profile::mailadmin::configure {
  $secret = lookup('profile::mailadmin::django::secret', String)
  $url = lookup('profile::mailserver::name', String)

  $configfile = '/etc/mailadmin/settings.ini'

  include ::profile::mailadmin::install

  ini_setting { 'mailadmin debug':
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

  ini_setting { 'mailadmin django secret':
    ensure  => present,
    path    => $configfile,
    section => 'general',
    setting => 'secret',
    value   => $secret,
    require => [
              Vcsrepo['/opt/mailadmin'],
              File['/etc/mailadmin'],
            ],
  }

  ini_setting { 'mailadmin main host':
    ensure  => present,
    path    => $configfile,
    section => 'hosts',
    setting => 'main',
    value   => $url,
    require => [
              Vcsrepo['/opt/mailadmin'],
              File['/etc/mailadmin'],
            ],
  }

  ini_setting { 'mailadmin staticpath':
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
