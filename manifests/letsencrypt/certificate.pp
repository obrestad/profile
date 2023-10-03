# Retrieves a certificate from letsencrypt.
define profile::letsencrypt::certificate (
  Array[String]       $domains,
  Boolean             $manage_cron = false,
  Optional[String[1]] $cron_before_command = undef,
  Optional[String[1]] $cron_success_command = undef,
) {
  require ::profile::letsencrypt

  $file = '/root/.certbot.domeneshop.secrets'

  letsencrypt::certonly { $name:
    domains              => $domains,
    cron_before_command  => $cron_before_command,
    cron_success_command => $cron_success_command,
    custom_plugin        => true,
    manage_cron          => $manage_cron,
    additional_args      => [
      '--authenticator dns-domeneshop',
      "--dns-domeneshop-credentials ${file}",
      '--dns-domeneshop-propagation-seconds 120',
    ],
  }
}
