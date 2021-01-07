# Installs and configures the letsencrypt client
class profile::letsencrypt {
  $certmail = lookup('profile::mail::certmaster', {
    'value_type' => String,
  })

  class { 'letsencrypt':
    config => {
      email  => $certmail, 
      server => 'https://acme-v02.api.letsencrypt.org/directory',
    }
  }
}
