# Configures an nginx-reverse-proxy to handle various ingress to docker
# containers. 
class profile::docker::ingress {
  $proxies = lookup('profile::docker::nginx::proxy', {
    value_type    => Hash[Hash],
    default_value => {}
  })

  $proxies.each | $target, $data | {
    profile::nginx::proxy { $target:
      alias  => pick($data['alias'], []),
      target => $data['target'],
    }
  }
}
