# Configures autoupgrades
class profile::baseconfig::upgrades {
  $upgrade_blacklist = hiera_array('profile::upgrade::exclude')
  $mail_recipient = hiera('profile::mail::recipient')

  class {'::unattended_upgrades':
    blacklist => $upgrade_blacklist,
    email     => $mail_recipient,
    repos     => {
      $::facts['os']['distro']['codename'] => {
        origin => $::facts['os']['distro']['id'],
        label  => 'Debian-Security',
      },
    },
  }
}
