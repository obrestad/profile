# Installs scripts to retrieve backups
class profile::backup::scripts {
  $scripts = {
    'backup-docker-mysql.sh' => 'backup-docker-mysql',
    'clean-backup.py'        => 'clean-backup',
  }

  $scripts.each | $source, $target | {
    file { "/usr/local/sbin/${target}":
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      source => "puppet:///modules/profile/scripts/${source}",
    }
  }
}
