class profile::mailserver {
  $mysql_name = hiera("profile::mail::db::name")
  $mysql_host = hiera("profile::mail::db::hose")
  $mysql_user = hiera("profile::mail::db::user")
  $mysql_pass = hiera("profile::mail::db::pass")

  $mail_mynetworks = hiera("profile::mail::mynetworks")

  $virtual_domains = @(END)
    user = ${mysql_user}
    password = ${mysql_pass}
    hosts = ${mysql_host}
    dbname = ${mysql_name}
    query = SELECT 1 FROM virtual_domains WHERE name='%s'
  END

  $virtual_mailbox = @(END)
    user = ${mysql_user}
    password = ${mysql_pass}
    hosts = ${mysql_host}
    dbname = ${mysql_name}
    query = SELECT 1 FROM virtual_users WHERE email='%s'
  END

  $virtual_alias = @(END)
    user = ${mysql_user}
    password = ${mysql_pass}
    hosts = ${mysql_host}
    dbname = ${mysql_name}
    query = SELECT destination FROM virtual_aliases WHERE source='%s'
  END

  $virtual_email2email = @(END)
    user = ${mysql_user}
    password = ${mysql_pass}
    hosts = ${mysql_host}
    dbname = ${mysql_name}
    query = SELECT email FROM virtual_users WHERE email='%s'
  END

  file { "/var/tmp/maildb-schema.sql":
    owner => "root",
    group => "root",
    mode  => 744,
    source => "puppet:///modules/profile/initial/maildb.sql",
  }->
  mysql::db { $mysql_name:
    user     => $mysql_user,
    password => $mysql_pass,
    host     => $mysql_host,
    grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE'],
    sql      => '/var/tmp/maildb-schema.sql',
    import_timeout => 900,
	require  => Class['::mysql::server'],
  }

  firewall { '010 accept incoming SMTP':
    proto  => 'tcp',
	dport  => 25,
    action => 'accept',
  }

  class { '::postfix::server':
    myhostname              => "$::fqdn",
    mydomain                => "$::domain",
    mail_name               => 'Rothaugane mail',
    myorigin              => "/etc/mailname",
    mydestination       => "localhost",
	mynetworks			=> $mail_mynetworks,

    ssl                   => 'mail.rothaugane.com',
    submission            => true,
	smtpd_tls_cert_file => '/etc/dovecot/dovecot.pem',
    smtpd_tls_key_file => '/etc/dovecot/private/dovecot.pem',

    extra_main_parameters => {
      'smtpd_tls_auth_only' => 'yes',
      'mailbox_size_limit' => '0',
	  'smtpd_relay_restrictions' => [
        'permit_mynetworks',
        'permit_sasl_authenticated',
        'reject_unauth_destination',
      ],
    },
    message_size_limit      => '15360000', # 15MB
    smtpd_sasl_auth       => true,

    virtual_mailbox_domains => [
      'mysql:/etc/postfix/mysql-virtual-mailbox-domains.cf',
    ],
    virtual_alias_maps      => [
      'mysql:/etc/postfix/mysql-virtual-alias-maps.cf',
      'mysql:/etc/postfix/mysql-virtual-email2email.cf',
    ],
	virtual_mailbox_maps => [
      'mysql:/etc/postfix/mysql-virtual-mailbox-maps.cf',
    ],
    virtual_transport         => 'lmtp:unix:private/dovecot-lmtp',

    smtpd_recipient_restrictions => [
      'permit_sasl_authenticated',
      'permit_mynetworks',
      'reject_unauth_destination',
      'reject_rbl_client zen.spamhaus.org',
      'reject_rhsbl_reverse_client dbl.spamhaus.org',
      'reject_rhsbl_helo dbl.spamhaus.org',
      'reject_rhsbl_sender dbl.spamhaus.org',
    ],

    smtpd_sender_restrictions => [
      'permit_mynetworks',
      'reject_unknown_sender_domain',
    ],
	
	recipient_delimiter => '-',
    inet_interfaces         => 'all',

    postgrey              => false,
    spamassassin          => false,
  }
}
