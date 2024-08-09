# Configures backup of a custom folder
define profile::backup::folder (
  $folder,
  $category = $name,
) {
  $usr = lookup('profile::backup::user', String)
  $base_path = lookup('profile::backup::base_path', String)

  $pth = "${base_path}/${category}/${::fqdn}"

  @@cron { "folder-backup-${::fqdn}-${name}":
    command => "/usr/local/sbin/backup-folders ${usr} ${::fqdn} ${pth} ${folder}",
    user    => $usr,
    hour    => [3, 9, 15, 21],
    minute  => [10],
    tag     => 'backup-pulls',
  }

  @@cron{ "clean-folder-backup-${::fqdn}-${name}":
    command => "/usr/local/sbin/clean-backup ${pth} --silent --delete",
    user    => $usr,
    hour    => [4],
    minute  => [37],
    tag     => 'clean-backups',
  }
}
