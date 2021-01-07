# Installs and configures the letsencrypt client
class profile::letsencrypt {
  $certmail = lookup('profile::mail::certmaster', {
    'value_type' => String,
  })

  require ::profile::utilities::pip3

  class { 'letsencrypt':
    config => {
      email  => $certmail, 
      server => 'https://acme-v02.api.letsencrypt.org/directory',
    }
  }

  package { 'certbot-dns-domeneshop':
    ensure   => 'present',
    provider => 'pip3',
  }
}
