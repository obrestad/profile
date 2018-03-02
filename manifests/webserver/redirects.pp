# Sets up various permanent redirects
class profile::webserver::redirects {
  $redirects = hiera_hash('profile::web::redirects')

  $redirects.each | $from, $to | {
    apache::vhost { "${from} http":
      servername      => $from,
      port            => '80',
      docroot         => "/var/www/${from}",
      redirect_source => ['/'],
      redirect_dest   => [$to],
      redirect_status => ['permanent'],
    }
  }
}
