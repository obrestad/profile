# Installs and Configures amavis for postfix use 
class profile::mailserver::amavis {
  package { 'amavisd-new':
    ensure => 'present',
  }

  service { 'amavisd-new':
    ensure => 'running',
  }

  $amavisconfig = { 'data' => {
    'final_spam_destiny' => 'D_DISCARD',
  }}

  file { '/etc/amavis/conf.d/60-puppet':
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => epp('profile/mailserver/amavis-config.epp', $amavisconfig),
    notify  => Service['amavisd-new'],
  }
}
