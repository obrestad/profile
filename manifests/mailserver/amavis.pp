# Installs and Configures amavis for postfix use 
class profile::mailserver::amavis {
  include ::profile::mailserver::amavis::install
  include ::profile::mailserver::amavis::service

  $postmaster = lookup('profile::mail::postmaster', String)
  $domains = lookup('profile::mail::domains', {
    'default_value' => [],
    'value_type'    => Array[String],
  })
  $dkim_keys = lookup('profile::mail::dkim::key::private', {
    'default_value' => {},
    'value_type'    => Hash[String, Hash[String, String]],
  })
  $domains_quoted = $domains.map | $domain | {
    "\'${domain}\'"
  }

  profile::mailserver::amavis::config { 'general':
    data => {
      'mydomain'                  => $facts['networking']['domain'],
      'myhostname'                => $facts['networking']['fqdn'],
      'mailfrom_notify_admin'     => $postmaster,
      'mailfrom_notify_recip'     => $postmaster,
      'mailfrom_notify_spamadmin' => $postmaster,
      'recipient_delimiter'       => '-',
      'notify_method'             => 'smtp:[127.0.0.1]:10025',
      'forward_method'            => 'smtp:[127.0.0.1]:10025',
      'local_domains_acl'         => [ '".$mydomain"' ] + $domains_quoted,
    }
  }

  profile::mailserver::amavis::config { 'dkim':
    data => {
      'enable_dkim_verification' => 1,
      'enable_dkim_signing'      => 1,
    }
  }

  file { '/etc/amavis/conf.d/65-DKIM':
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Service['amavisd-new'],
    source => 'puppet:///modules/profile/config/amavis/dkim.conf',
  }

  $dkim_keys.each | $domain, $keys | {
    $keys.each | $keyname, $key | {
      file { "/etc/amavis/${domain}-${selector}.key":
        owner   => 'root',
        group   => 'amavis',
        mode    => '0640',
        notify  => Service['amavisd-new'],
        content => $dkim_key,
      }

      profile::mailserver::amavis::config::dkim { $domain :
        domain => $domain,
        keyfile => "/etc/amavis/${domain}-${selector}.key",
        keyname => $selector,
      }
    }
  }

  profile::mailserver::amavis::config { 'spamfilter':
    data => {
      'sa_tag_level_deflt'      => -999,
      'spam_quarantine_to'      => undef,
      'final_spam_destiny'      => 'D_DISCARD',
      'bypass_spam_checks_maps' => [
        '\%bypass_spam_checks',
        '\@bypass_spam_checks_acl',
        '\$bypass_spam_checks_re',
      ],
    }
  }
}
