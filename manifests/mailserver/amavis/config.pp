# Creates an amavis config-file
define profile::mailserver::amavis::config (
  Hash[String, Variant[String, Integer, Undef, Array[String]]] $data
) {
  include ::profile::mailserver::amavis::service

  $amavisconfig = { 'data' => $data }
  file { "/etc/amavis/conf.d/60-${name}":
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => epp('profile/mailserver/amavis-config.epp', $amavisconfig),
    notify  => Service['amavisd-new'],
  }
}
