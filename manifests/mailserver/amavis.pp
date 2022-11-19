# Installs and Configures amavis for postfix use 
class profile::mailserver::amavis {
  include ::profile::mailserver::amavis::install
  include ::profile::mailserver::amavis::service

  profile::mailserver::amavis::config { 'spamfilter':
    data => {
      'final_spam_destiny' => 'D_DISCARD',
      'bypass_spam_checks_maps' => [
        '\%bypass_spam_checks',
        '\@bypass_spam_checks_acl',
        '\$bypass_spam_checks_re',
      ],
    }
  }
}
