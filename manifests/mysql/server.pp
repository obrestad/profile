# Installs a simple mysql server
class profile::mysql::server {
  $mysql_root_pw = hiera('profile::mysql::rootpw')

  class { '::mysql::server':
    root_password           => $mysql_root_pw,
    remove_default_accounts => true,
    override_options        => {
      'mysqld' => {
        'bind-address' => '0.0.0.0',
      },
    },
  }
}
