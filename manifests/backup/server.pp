# Configures the backupserver to both fetch backups, and to clean old(er)
# backups.
class profile::backup::server {
  include ::profile::backup::scripts

  Cron <<| tag == 'backup-pulls' |>>
  Cron <<| tag == 'clean-backups' |>>
}
