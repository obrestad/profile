# Configures backup of a mysql database.
define profile::mysql::backup (
  String $username,
  String $password,
  String $database = $name,
  String $hostname = $::fqdn,
){
  $params = "${hostname} ${username} ${password} ${database}"
  @@cron { "mysql-backup-${hostname}-${database}":
    command => "/usr/local/sbin/backup-mysql ${params}",
    user    => 'backups',
    hour    => fqdn_rand(24, "${hostname}-${database}"),
    minute  => fqdn_rand(60, "${hostname}-${database}"),
    tag     => 'backup-pulls',
  }
}
