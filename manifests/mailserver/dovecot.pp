class profile::mailserver::dovecot {
  class { '::profile::mailserver::dovecot::install' : } ->
  class { '::profile::mailserver::dovecot::conf' : }
}
