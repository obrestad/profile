# Installs scripts to retrieve backups
class profile::backup::scripts {
  $scripts = {
    'backup-docker-mysql.sh' => 'backup-docker-mysql',
    'backup-folders.sh'      => 'backup-folders',
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

  file { '/var/lib/backup-lib.sh':
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/profile/scripts/backup-lib.sh',
  }
}
