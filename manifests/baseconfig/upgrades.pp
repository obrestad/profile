# Configures autoupgrades
class profile::baseconfig::upgrades {
  $upgrade_blacklist = lookup('profile::upgrade::exclude', {
    'default_value' => [],
    'merge'         => 'unique',
    'value_type'    => Array[String],
  })
  $mail_recipient = lookup('profile::mail::admin', {
    'value_type' => String,
  })

  class {'::unattended_upgrades':
    blacklist     => $upgrade_blacklist,
    mail          => {
      'to'            => $mail_recipient,
      'only_on_error' => false,
    },
    minimal_steps => false,
  }
}
