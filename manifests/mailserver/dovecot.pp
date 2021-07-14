# Installs and configures a dovecot-server
class profile::mailserver::dovecot {
  include ::profile::mailserver::dovecot::conf
  include ::profile::mailserver::dovecot::install
  include ::profile::mailserver::firewall::imap
  
  Class['::profile::mailserver::dovecot::install'] 
  -> Class['::profile::mailserver::dovecot::conf']
}
