# Retrieves a certificate from letsencrypt.
define profile::letsencrypt::certificate (
  Array[String] $domains,
) {
  require ::profile::letsencrypt

  $file = '/root/.certbot.domeneshop.secrets'

  letsencrypt::certonly { $name:
    domains         => $domains,
    custom_plugin   => true,
    additional_args => [
      '--authenticator certbot-dns-domeneshop:dns-domeneshop',
      "--certbot-dns-domeneshop:dns-domeneshop-credentials ${file}",
      '--certbot-dns-domeneshop:dns-domeneshop-propagation-seconds 120',
    ],
  }
}
