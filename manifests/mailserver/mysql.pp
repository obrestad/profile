# Creates a database for the mailing system, and configures postfix to use it
# for mail delivery
class profile::mailserver::mysql {
  $mysql_name = hiera('profile::mail::db::name')
  $mysql_host = hiera('profile::mail::db::host')
  $mysql_user = hiera('profile::mail::db::user')
  $mysql_pass = hiera('profile::mail::db::pass')

  $virtual_domains = "user = ${mysql_user}
password = ${mysql_pass}
hosts = ${mysql_host}
dbname = ${mysql_name}
query = SELECT 1 FROM resources_domain WHERE name='%s'"

  $virtual_mailbox = "user = ${mysql_user}
password = ${mysql_pass}
hosts = ${mysql_host}
dbname = ${mysql_name}
query = SELECT 1 FROM resources_account WHERE email='%s'"

  $virtual_alias = "user = ${mysql_user}
password = ${mysql_pass}
hosts = ${mysql_host}
dbname = ${mysql_name}
query = SELECT destination FROM resources_alias WHERE source='%s'"

  $virtual_email2email = "user = ${mysql_user}
password = ${mysql_pass}
hosts = ${mysql_host}
dbname = ${mysql_name}
query = SELECT email FROM resources_account WHERE email='%s'"

  file { '/etc/postfix/mysql-virtual-mailbox-domains.cf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    content => $virtual_domains,
    require => Class['::profile::mailserver::postfix'],
  }
  file { '/etc/postfix/mysql-virtual-mailbox-maps.cf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    content => $virtual_mailbox,
    require => Class['::profile::mailserver::postfix'],
  }
  file { '/etc/postfix/mysql-virtual-alias-maps.cf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    content => $virtual_alias,
    require => Class['::profile::mailserver::postfix'],
  }
  file { '/etc/postfix/mysql-virtual-email2email.cf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    content => $virtual_email2email,
    require => Class['::profile::mailserver::postfix'],
  }

  mysql::db { $mysql_name:
    user           => $mysql_user,
    password       => $mysql_pass,
    host           => $mysql_host,
    grant          => ['CREATE', 'ALTER',
                        'DELETE', 'INSERT',
                        'SELECT', 'UPDATE',
                        'INDEX', 'DROP',
                      ],
    require        => Class['::mysql::server'],
  }
}
