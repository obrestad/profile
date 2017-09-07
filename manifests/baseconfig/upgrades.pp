# Configures autoupgrades
class profile::baseconfig::upgrades {
  $upgrade_blacklist = hiera_array('profile::upgrade::exclude')
  $mail_recipient = hiera('profile::mail::recipient')

  class {'::unattended_upgrades':
    blacklist     => $upgrade_blacklist,
    mail          => $mail_recipient,
    minimal_steps => false,
  }
}
