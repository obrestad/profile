# Installs a samba-server and sets up users and shares.
class profile::samba {
  include ::profile::samba::firewall
  include ::profile::samba::shares
  include ::profile::samba::users

  $interface = lookup('profile::samba::interface', {
    'value_type'    => String,
  })

  class {'samba::server':
    workgroup     => 'rothaugane',
    server_string => 'Antoccino',
    interfaces    => "${interface} lo",
    security      => 'user'
  }
}
