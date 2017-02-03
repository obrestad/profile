# Installs a simple mysql server, and configures munin monitoring of it.
class profile::mysqlserver {
  $mysql_root_pw = hiera('profile::mysql::rootpw')

  class { '::mysql::server':
    root_password           => $mysql_root_pw,
    remove_default_accounts => true,
  }

#  munin::plugin { 'mysql_bin_relay_log':
#    ensure => link,
#    target => 'mysql_',
#    config => [
#      'user root',
#      "env.mysqlpassword ${mysql_root_pw}",
#    ],
#  }
#
#  munin::plugin { 'mysql_commands':
#    ensure => link,
#    target => 'mysql_',
#    config => [
#      'user root',
#      "env.mysqlpassword ${mysql_root_pw}",
#    ],
#  }
#
#  munin::plugin { 'mysql_connections':
#    ensure => link,
#    target => 'mysql_',
#    config => [
#      'user root',
#      "env.mysqlpassword ${mysql_root_pw}",
#    ],
#  }
#
#  munin::plugin { 'mysql_files_tables':
#    ensure => link,
#    target => 'mysql_',
#    config => [
#      'user root',
#      "env.mysqlpassword ${mysql_root_pw}",
#    ],
#  }
#
#  munin::plugin { 'mysql_innodb_bpool':
#    ensure => link,
#    target => 'mysql_',
#    config => [
#      'user root',
#      "env.mysqlpassword ${mysql_root_pw}",
#    ],
#  }
#
#  munin::plugin { 'mysql_innodb_bpool_act':
#    ensure => link,
#    target => 'mysql_',
#    config => [
#      'user root',
#      "env.mysqlpassword ${mysql_root_pw}",
#    ],
#  }
#
#  munin::plugin { 'mysql_innodb_insert_buf':
#    ensure => link,
#    target => 'mysql_',
#    config => [
#      'user root',
#      "env.mysqlpassword ${mysql_root_pw}",
#    ],
#  }
#
#  munin::plugin { 'mysql_innodb_io':
#    ensure => link,
#    target => 'mysql_',
#    config => [
#      'user root',
#      "env.mysqlpassword ${mysql_root_pw}",
#    ],
#  }
#
#  munin::plugin { 'mysql_innodb_io_pend':
#    ensure => link,
#    target => 'mysql_',
#    config => [
#      'user root',
#      "env.mysqlpassword ${mysql_root_pw}",
#    ],
#  }
#
#  munin::plugin { 'mysql_innodb_log':
#    ensure => link,
#    target => 'mysql_',
#    config => [
#      'user root',
#      "env.mysqlpassword ${mysql_root_pw}",
#    ],
#  }
#
#  munin::plugin { 'mysql_innodb_rows':
#    ensure => link,
#    target => 'mysql_',
#    config => [
#      'user root',
#      "env.mysqlpassword ${mysql_root_pw}",
#    ],
#  }
#
#  munin::plugin { 'mysql_innodb_semaphores':
#    ensure => link,
#    target => 'mysql_',
#    config => [
#      'user root',
#      "env.mysqlpassword ${mysql_root_pw}",
#    ],
#  }
#
#  munin::plugin { 'mysql_innodb_tnx':
#    ensure => link,
#    target => 'mysql_',
#    config => [
#      'user root',
#      "env.mysqlpassword ${mysql_root_pw}",
#    ],
#  }
#
#  munin::plugin { 'mysql_myisam_indexes':
#    ensure => link,
#    target => 'mysql_',
#    config => [
#      'user root',
#      "env.mysqlpassword ${mysql_root_pw}",
#    ],
#  }
#
#  munin::plugin { 'mysql_network_traffic':
#    ensure => link,
#    target => 'mysql_',
#    config => [
#      'user root',
#      "env.mysqlpassword ${mysql_root_pw}",
#    ],
#  }
#
#  munin::plugin { 'mysql_qcache':
#    ensure => link,
#    target => 'mysql_',
#    config => [
#      'user root',
#      "env.mysqlpassword ${mysql_root_pw}",
#    ],
#  }
#
#  munin::plugin { 'mysql_qcache_mem':
#    ensure => link,
#    target => 'mysql_',
#    config => [
#      'user root',
#      "env.mysqlpassword ${mysql_root_pw}",
#    ],
#  }
#
#  munin::plugin { 'mysql_replication':
#    ensure => link,
#    target => 'mysql_',
#    config => [
#      'user root',
#      "env.mysqlpassword ${mysql_root_pw}",
#    ],
#  }
#
#  munin::plugin { 'mysql_select_types':
#    ensure => link,
#    target => 'mysql_',
#    config => [
#      'user root',
#      "env.mysqlpassword ${mysql_root_pw}",
#    ],
#  }
#
#  munin::plugin { 'mysql_slow':
#    ensure => link,
#    target => 'mysql_',
#    config => [
#      'user root',
#      "env.mysqlpassword ${mysql_root_pw}",
#    ],
#  }
#
#  munin::plugin { 'mysql_sorts':
#    ensure => link,
#    target => 'mysql_',
#    config => [
#      'user root',
#      "env.mysqlpassword ${mysql_root_pw}",
#    ],
#  }
#
#  munin::plugin { 'mysql_table_locks':
#    ensure => link,
#    target => 'mysql_',
#    config => [
#      'user root',
#      "env.mysqlpassword ${mysql_root_pw}",
#    ],
#  }
#
#  munin::plugin { 'mysql_tmp_tables':
#    ensure => link,
#    target => 'mysql_',
#    config => [
#      'user root',
#      "env.mysqlpassword ${mysql_root_pw}",
#    ],
#  }
#
#  munin::plugin { 'mysql_bytes':
#    ensure => link,
#  }
#
#  munin::plugin { 'mysql_innodb':
#    ensure => link,
#  }
#
#  munin::plugin { 'mysql_queries':
#    ensure => link,
#  }
#
#  munin::plugin { 'mysql_slowqueries':
#    ensure => link,
#  }
#
#  munin::plugin { 'mysql_threads':
#    ensure => link,
#  }

}
