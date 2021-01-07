# Configures letsencrypt to use the domeneshop.no API for DNS-based
# domain-validation. 
class profile::letsencrypt {
  $token = lookup('profile::domeneshop::token')
  $secret = lookup('profile::domeneshop::secret')

  require ::profile::utilities::pip3

  package { 'certbot-dns-domeneshop':
    ensure   => 'present',
    provider => 'pip3',
  }

  ini_setting { 'certbot domeneshop token':
    ensure  => 'present',
    path    => '/root/.certbot.domeneshop.secrets',
    section => '',
    setting => 'certbot_dns_domeneshop:dns_domeneshop_client_token',
    value   => $token,
  }

  ini_setting { 'certbot domeneshop secret':
    ensure  => 'present',
    path    => '/root/.certbot.domeneshop.secrets',
    section => '',
    setting => 'certbot_dns_domeneshop:dns_domeneshop_client_secret',
    value   => $secret,
  }
}
