# Installs a simple mysql server
class profile::mysql::server {
  $mysql_bind = lookup('profile::mysql::bind', {
    'default_value' => '127.0.0.1',
    'value_type'    => Stdlib::IP::Address::Nosubnet,
  })
  $mysql_root_pw = lookup('profile::mysql::rootpw', String)

  class { '::mysql::server':
    root_password           => $mysql_root_pw,
    remove_default_accounts => true,
    override_options        => {
      'mysqld' => {
        'bind-address' => $mysql_bind,
      },
    },
  }
}
