# Configures an nginx-reverse-proxy to handle various ingress to docker
# containers. 
class profile::docker::ingress {
  $proxies = lookup('profile::docker::nginx::proxy', {
    value_type    => Hash[String, Hash],
    default_value => {}
  })

  $proxies.each | $target, $data | {
    if('cidrs' in $data) {
      $location_deny = ['all']
      $location_allow = $data['cidrs']
    } else {
      $location_allow = []
      $location_deny = []
    }

    profile::nginx::proxy { $target:
      alias          => pick($data['alias'], []),
      location_allow => $location_allow,
      location_deny  => $location_deny,
      request_size   => $data['request_size'],
      target         => $data['target'],
    }
  }
}
