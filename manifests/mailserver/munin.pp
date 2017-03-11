# This class sets up mailserver monitoring
class profile::mailserver::munin {
  munin::plugin { 'spamstats':
    ensure => link,
  }
}
