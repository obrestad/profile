# This class installs and configures the spamfilter
class profile::mailserver::spamfilter {
  package {['spamassassin', 'spamc']:
    ensure => 'present',
  }

  service { 'spamassassin':
    ensure => 'running',
    enable => true,
  }

  file { '/var/lib/spamassassin/bayes/':
    ensure  => 'directory',
    user    => 'debian_spamd',
    group   => 'debian_spamd',
    mode    => '0755',
    require => Package['spamassassin'],
  }

  ini_setting { 'spamfilter_header':
    ensure            => present,
    path              => '/etc/spamassassin/local.cf',
    setting           => 'rewrite_header',
    value             => 'Subject **SPAM**',
    key_val_separator => ' ',
    notify            => Service['spamassassin'],
  }

  ini_setting { 'spamfilter_report_safe':
    ensure            => present,
    path              => '/etc/spamassassin/local.cf',
    setting           => 'report_safe',
    value             => '1',
    key_val_separator => ' ',
    notify            => Service['spamassassin'],
  }

  ini_setting { 'spamfilter_use_bayes':
    ensure            => present,
    path              => '/etc/spamassassin/local.cf',
    setting           => 'use_bayes',
    value             => '1',
    key_val_separator => ' ',
    notify            => Service['spamassassin'],
  }

  ini_setting { 'spamfilter_bayes_auto_learn':
    ensure            => present,
    path              => '/etc/spamassassin/local.cf',
    setting           => 'bayes_auto_learn',
    value             => '1',
    key_val_separator => ' ',
    notify            => Service['spamassassin'],
  }

  ini_setting { 'spamfilter_bayes_path':
    ensure            => present,
    path              => '/etc/spamassassin/local.cf',
    setting           => 'bayes_path',
    value             => '/var/lib/spamassassin/bayes/bayes_',
    key_val_separator => ' ',
    notify            => Service['spamassassin'],
  }

  ini_setting { 'spamfilter_bayes_file_mode':
    ensure            => present,
    path              => '/etc/spamassassin/local.cf',
    setting           => 'bayes_file_mode',
    value             => '0666',
    key_val_separator => ' ',
    notify            => Service['spamassassin'],
  }
}
