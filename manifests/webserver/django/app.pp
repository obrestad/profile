# This class installs and configures a django application
class profile::webserver::django::app (
  String       $dbhost,
  String       $dbpassword,
  String       $secret,
  String       $sourcerepo,
  Stdlib::Fqdn $url,
  String       $appname    = $name,
  String       $dbusername = $name,
  String       $dbname     = $name,
  Boolean      $tls        = true,
) {
  require ::profile::webserver::django::packages

  ::profile::webserver::django::app::config { $name :
    secret => $secret,
    url    => $url,
  }

  ::profile::webserver::django::app::config::db { $name :
    dbhost   => $dbhost,
    username => $dbusername,
    password => $dbpassword,
    dbname   => $dbname,
  }

  ::profile::webserver::django::app::install { $name :
    sourcerepo => $sourcerepo,
  }

  ::profile::webserver::django::app::vhost { $name :
    appname => $appname,
    tls     => $tls,
    url     => $url,
  }
}
