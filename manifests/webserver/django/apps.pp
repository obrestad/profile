# This class installs multiple django apps based on the information in hiera.
class profile::webserver::django::apps {
  require ::profile::webserver::django::packages

  $apps = hiera_array('profile::web::djangoapps')

  $apps.each | $appname | {
    ::profile::webserver::django::apps::configure { $appname : }
    ::profile::webserver::django::apps::database { $appname : }
    ::profile::webserver::django::apps::install { $appname : }
    ::profile::webserver::django::apps::vhost { $appname : }
  }
}
