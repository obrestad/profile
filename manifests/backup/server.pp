# Configures the backupserver
class profile::backup::server {
  include ::profile::users::backup

  Cron <<| tag == 'clean-backups' |>>
}
