class profile::mysqlserver {
  class { '::mysql::server':
    root_password           => hiera("profile::mysql::rootpw"),
    remove_default_accounts => true,
  }
}
