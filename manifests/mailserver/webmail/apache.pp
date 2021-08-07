# Configures apache for the webmail
class profile::mailserver::webmail::apache {
  $webmailname = hiera('profile::mailserver::web::name')

  include ::apache::mod::php
  include ::apache::mod::rewrite
  require ::profile::mailserver::webmail::certs
  require ::profile::mailserver::webmail::install
  require ::profile::webserver

  apache::vhost { "${webmailname} http":
    servername      => $webmailname,
    port            => '80',
    docroot         => '/var/lib/roundcube',
    redirect_source => ['/'],
    redirect_dest   => ["https://${webmailname}/"],
    redirect_status => ['permanent'],
  }
  apache::vhost { "${webmailname} https":
    servername  => $webmailname,
    port        => '443',
    docroot     => '/var/lib/roundcube/',
    ssl         => true,
    ssl_cert    => "/etc/letsencrypt/live/${webmailname}/fullchain.pem",
    ssl_key     => "/etc/letsencrypt/live/${webmailname}/privkey.pem",
    directories => [
      { path           => '/var/lib/roundcube/',
        options        => ['+FollowSymLinks'],
        allow_override => ['All'],
        require        => 'all granted',
      },
      { path           => '/var/lib/roundcube/config',
        options        => ['-FollowSymLinks'],
        allow_override => ['None'],
      },
      { path           => '/var/lib/roundcube/temp',
        options        => ['-FollowSymLinks'],
        allow_override => ['None'],
        require        => 'all denied',
      },
      { path           => '/var/lib/roundcube/logs',
        options        => ['-FollowSymLinks'],
        allow_override => ['None'],
        require        => 'all denied',
      },
    ],
  }
}
