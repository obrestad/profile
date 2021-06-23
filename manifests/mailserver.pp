# Installs and configures a MX, mailserver, spamfilter and a webmail-interface.
class profile::mailserver {
  include ::profile::mailadmin
  # include ::profile::mailserver::spamfilter
  # include ::profile::mailserver::dovecot
  # include ::profile::mailserver::postfix
  # include ::profile::mailserver::mysql
  # include ::profile::mailserver::firewall
  # include ::profile::mailserver::webmail
}
