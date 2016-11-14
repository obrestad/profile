class profile::mailserver {
  include ::profile::mailserver::dovecot
  include ::profile::mailserver::postfix
  include ::profile::mailserver::mysql
  include ::profile::mailserver::firewall
  include ::profile::mailserver::web
  include ::profile::mailserver::webmail
  include ::profile::mailserver::backup
}
