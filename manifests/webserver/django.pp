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
        false => $name,
      },
      dbusername => 'username' in $data['database'] ? {
        true  => $data['database']['username'],
        false => $name,
      },
      dbname     => 'name' in $data['database'] ? {
        true  => $data['database']['name'],
        false => $name,
      },
      tls        => 'tls' in $data ? {
        true  => $data['tls'],
        false => false,
      },
    }
  }
}
