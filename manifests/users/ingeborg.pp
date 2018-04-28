# Create a user for ingeborg
class profile::users::ingeborg {
  user { 'ingeborg':
    ensure      => present,
    gid         => 'users',
    require     => Group['users'],
    groups      => [],
    uid         => 802,
    shell       => '/bin/false',
    home        => '/home/ingeborg',
    managehome  => true,
    password    => '*', 
  }
}
