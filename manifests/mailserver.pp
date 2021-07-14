# Installs and configures a MX, mailserver, spamfilter and a webmail-interface.
class profile::mailserver {
  include ::profile::mailadmin
  include ::profile::spamfilter
  include ::profile::mailserver::dovecot
  include ::profile::mailserver::postfix
  # include ::profile::mailserver::webmail
}
