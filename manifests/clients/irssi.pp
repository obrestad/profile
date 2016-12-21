# Installs a ubnt controller
class profile::clients::irssi {
  package { 'irssi':
    ensure  => 'present',
  }
}
