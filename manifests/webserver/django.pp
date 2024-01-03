# This class installs multiple django apps based on the information in hiera.
class profile::webserver::django {
  $apps = lookup('profile::web::django::apps', {
    'default_value' => {},
    'value_type'    => Hash,
  })

  $apps.each | $appname, $data | {
    ::profile::webserver::django::app { $appname:
      dbhost     => $data['database']['host'],
      dbpassword => $data['database']['password'],
      secret     => $data['secret'],
      sourcerepo => $data['sourcerepo'],
      url        => $data['url'],
      appname    => 'appname' in $data ? {
        true  => $data['appname'],
        false => $appname,
      },
      dbusername => 'username' in $data['database'] ? {
        true  => $data['database']['username'],
        false => $appname,
      },
      dbname     => 'name' in $data['database'] ? {
        true  => $data['database']['name'],
        false => $appname,
      },
      tls        => 'tls' in $data ? {
        true  => $data['tls'],
        false => false,
      },
    }
  }
  
  $paths = $apps.map | $appname, $data | {
    "/opt/${appname}/"
  }

  class { 'apache::mod::wsgi':
    mod_path         => '/usr/lib/apache2/modules/mod_wsgi.so',
    package_name     => 'libapache2-mod-wsgi-py3',
    wsgi_python_path => join($paths, ':'),
  }

}
