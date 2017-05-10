# Configures the ssh client and servers
class profile::baseconfig::ssh {
  class { 'ssh':
    storeconfigs_enabled => true,
    server_options       => {
      'Port'                     => [22],
      'PasswordAuthentication'   => 'yes',
      'X11Forwarding'            => 'no',
      'Match User remote-backup' => {
        'ChrootDirectory'        => '/srv/backup/',
        'ForceCommand'           => 'internal-sftp',
        'PasswordAuthentication' => 'no',
        'AllowTcpForwarding'     => 'no',
      },
    },
  }
}
