# Installs and configures a MX, mailserver, spamfilter and a webmail-interface.
class profile::mailserver {
  include ::profile::mailadmin
  include ::profile::mailserver::backup
  include ::profile::mailserver::dovecot
  include ::profile::mailserver::amavis
  include ::profile::mailserver::postfix
  include ::profile::spamfilter
  include ::profile::mailserver::webmail
}
