# Configures the firewall for the unifi controller 
class profile::unifi {
  profile::firewall::generic { 'Unifi UAP':
    protocol => 'tcp',
    port     => [ 8080 ],
  }
  
  profile::firewall::generic { 'Unifi STUN':
    protocol => 'udp',
    port     => [ 3478 ],
  }
}
