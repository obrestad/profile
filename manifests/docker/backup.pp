# Configures backup of various services run in docker.
class profile::docker::backup {
  $mysql_containers = lookup('profile::docker::backup::mysql', {
    'default_value' => [],
    'value_type'    => Hash[String, Hash[String, Strin]],
  })

  $mysql_containers.each | $container, $data | {
    $db = $data['database']
    $user = $data['username']
    $pass = $data['password']

    $params = "${::fqdn} ${container} ${user} ${pass} ${db}",
    @@cron { "docker-mysql-backup-${::fqdn}-${container}":
      command => "/usr/local/sbin/backup-docker-mysql ${params}",
      user    => 'backup',
      hour    => fqdn_rand(24, "${::fqdn}-${container}"),
      minute  => fqdn_rand(60, "${::fqdn}-${container}"),
      tag     => 'backup',
    }
  }
}
