# Configures users and passwords for the samba-server 
class profile::samba::users {
  $samba_users = lookup('profile::user::samba', {
    'value_type'    => Hash,
    'default_value' => {},
  })

  $samba_users.each | $username, $password | {
    samba::server::user { $username:
      password => $password,
    }
  }
}
