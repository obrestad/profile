class profile::mailserver::mysql {
  $mysql_name = hiera("profile::mail::db::name")
  $mysql_host = hiera("profile::mail::db::host")
  $mysql_user = hiera("profile::mail::db::user")
  $mysql_pass = hiera("profile::mail::db::pass")

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

  file { "/etc/postfix/mysql-virtual-mailbox-domains.cf":
    owner   => "root",
    group   => "root",
	ensure  => "file",
    mode    => 744,
	content => $virtual_domains,
	require => Class['::postfix::server'],
  }
  file { "/etc/postfix/mysql-virtual-mailbox-maps.cf":
    owner   => "root",
    group   => "root",
	ensure  => "file",
    mode    => 744,
	content => $virtual_mailbox,
	require => Class['::postfix::server'],
  }
  file { "/etc/postfix/mysql-virtual-alias-maps.cf":
    owner   => "root",
    group   => "root",
	ensure  => "file",
    mode    => 744,
	content => $virtual_alias,
	require => Class['::postfix::server'],
  }
  file { "/etc/postfix/mysql-virtual-email2email.cf":
    owner   => "root",
    group   => "root",
	ensure  => "file",
    mode    => 744,
	content => $virtual_email2email,
	require => Class['::postfix::server'],
  }

  file { "/var/local/maildb-initial.sql":
    owner => "root",
    group => "root",
    mode  => "644",
    source => "puppet:///modules/profile/initial/maildb.sql",
	require => Class['::mysql::server'],
  }
}
