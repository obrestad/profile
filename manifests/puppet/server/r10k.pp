# Installs and configures r10k 
class profile::puppet::server::r10k {
  $r10krepo = lookup('profile::puppet::r10k::repo', Stdlib::HTTPUrl)

  # Install and configure r10k
  class { 'r10k':
    remote => $r10krepo,
  }
}
