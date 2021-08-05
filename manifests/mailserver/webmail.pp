# Installs and configures the webmail interface
class profile::mailserver::webmail {
  include ::profile::mailserver::webmail::apache
  include ::profile::mailserver::webmail::install
  include ::profile::mailserver::webmail::config
  include ::profile::mailserver::webmail::database
}
