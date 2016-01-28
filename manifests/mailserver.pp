class profile::mailserver {
  class { '::postfix::server':
    myhostname              => "$::fqdn",
    mydomain                => "$::domain",
    mydestination           => "\$myhostname, localhost.\$mydomain, localhost, $fqdn",
    inet_interfaces         => 'all',
    message_size_limit      => '15360000', # 15MB
    mail_name               => 'Rothaugane mail',
    virtual_mailbox_domains => [
      'proxy:mysql:/etc/postfix/mysql_virtual_domains_maps.cf',
    ],
    virtual_alias_maps      => [
      'proxy:mysql:/etc/postfix/mysql_virtual_alias_maps.cf',
      'proxy:mysql:/etc/postfix/mysql_virtual_alias_domain_maps.cf',
      'proxy:mysql:/etc/postfix/mysql_virtual_alias_domain_catchall_maps.cf',
    ],
    virtual_transport         => 'dovecot',
    # if you want dovecot to deliver user+foo@example.org to user@example.org,
    # uncomment this: (c.f. http://wiki2.dovecot.org/LDA/Postfix#Virtual_users)
    # dovecot_destination     => '${user}@${nexthop}',
    smtpd_sender_restrictions => [
      'permit_mynetworks',
      'reject_unknown_sender_domain',
    ],
    smtpd_recipient_restrictions => [
      'permit_sasl_authenticated',
      'permit_mynetworks',
      'reject_unauth_destination',
    ],
    smtpd_sasl_auth       => true,
    sender_canonical_maps => 'regexp:/etc/postfix/sender_canonical',
    ssl                   => 'mail.rothaugane.com',
    submission            => true,
    header_checks         => [
      '# Remove LAN (Webmail) headers',
      '/^Received: from .*\.example\.ici/ IGNORE',
      '# Sh*tlist',
      '/^From: .*@(example\.com|example\.net)/ REJECT Spam, go away',
      '/^From: .*@(lcfnl\.com|.*\.cson4\.com|.*\.idep4\.com|.*\.gagc4\.com)/  REJECT user unknown',
    ],
    postgrey              => true,
    spamassassin          => true,
    sa_skip_rbl_checks    => '0',
    spampd_children       => '4',
    # Send all emails to spampd on 10026
    smtp_content_filter   => 'smtp:127.0.0.1:10026',
    # This is where we get emails back from spampd
    master_services       => [ '127.0.0.1:10027 inet n - n -20 smtpd'],
  }
}
