class profile::mailserver {
  include ::profile::mailserver::postfix
  include ::profile::mailserver::mysql
  include ::profile::mailserver::firewall
}
