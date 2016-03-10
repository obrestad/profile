class profile::mailserver::mysql {
  $mysql_name = hiera('profile::mail::db::name')
  $mysql_host = hiera('profile::mail::db::host')
  $mysql_user = hiera('profile::mail::db::user')
  $mysql_pass = hiera('profile::mail::db::pass')

  $virtual_domains = "user = ${mysql_user}
password = ${mysql_pass}
hosts = ${mysql_host}
dbname = ${mysql_name}
query = SELECT 1 FROM virtual_domains WHERE name='%s'"

  $virtual_mailbox = "user = ${mysql_user}
password = ${mysql_pass}
hosts = ${mysql_host}
dbname = ${mysql_name}
query = SELECT 1 FROM virtual_users WHERE email='%s'"

  $virtual_alias = "user = ${mysql_user}
password = ${mysql_pass}
hosts = ${mysql_host}
dbname = ${mysql_name}
query = SELECT destination FROM virtual_aliases WHERE source='%s'"

  $virtual_email2email = "user = ${mysql_user}
password = ${mysql_pass}
hosts = ${mysql_host}
dbname = ${mysql_name}
query = SELECT email FROM virtual_users WHERE email='%s'"

  file { '/etc/postfix/mysql-virtual-mailbox-domains.cf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => 744,
    content => $virtual_domains,
    require => Class['::profile::mailserver::postfix'],
  }
  file { '/etc/postfix/mysql-virtual-mailbox-maps.cf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => 744,
    content => $virtual_mailbox,
    require => Class['::profile::mailserver::postfix'],
  }
  file { '/etc/postfix/mysql-virtual-alias-maps.cf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => 744,
    content => $virtual_alias,
    require => Class['::profile::mailserver::postfix'],
  }
  file { '/etc/postfix/mysql-virtual-email2email.cf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => 744,
    content => $virtual_email2email,
    require => Class['::profile::mailserver::postfix'],
  }

  file { '/var/local/maildb-initial.sql':
    owner  => 'root',
    group  => 'root',
    mode   => '644',
    source => 'puppet:///modules/profile/initial/maildb.sql',
  } ->
  mysql::db { $mysql_name:
    user           => $mysql_user,
    password       => $mysql_pass,
    host           => $mysql_host,
    grant          => ['SELECT', 'UPDATE'],
    sql            => '/var/local/maildb-initial.sql',
    import_timeout => 900,
    require        => Class['::mysql::server'],
  }
}
