# Configures shares for the samba server 
class profile::samba::shares {
  $shares = lookup('profile::samba::shares', {
    'value_type'    => Hash,
    'default_value' => {},
  })

  $shares.each | $sharename, $data | {
    samba::server::share { $sharename :
      comment       => $data['comment'],
      path          => $data['path'],
      guest_only    => false,
      guest_ok      => $data['guest_ok'],
      guest_account => 'nobody',
      browsable     => $data['browsable'],
      force_group   => 'users',
      read_only     => $data['read_only'],
    }
  }
}
