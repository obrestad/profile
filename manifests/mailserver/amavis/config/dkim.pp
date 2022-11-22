# Creates an amavis config-file
define profile::mailserver::amavis::config::dkim (
  String $domain,
  String $keyname,
  String $keyfile
) {
  include ::profile::mailserver::amavis::service

  $config = { 
    'domain'  => $domain,
    'keyname' => $keyname,
    'keyfile' => $keyfile,
  }
  file { "/etc/amavis/conf.d/65-dkim-${name}":
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => epp('profile/mailserver/amavis-dkim.epp', $config),
    notify  => Service['amavisd-new'],
  }
}
