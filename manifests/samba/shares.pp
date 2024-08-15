# Configures shares for the samba server 
class profile::samba::shares {
  $shares = lookup('profile::samba::shares', {
    'value_type'    => Hash,
    'default_value' => {},
  })

  # If there are at least one share:
  if($shares =~ Hash[String, Hash, 1]) {
    # Collect all the share paths:
    $folders = $shares.map | $sharename, $data | {
      $data['path']
    }

    # And initiate backup of them
    ::profile::backup::folder {"SambaShares-${::fqdn}":
      category => 'sambashares',
      folder   => $folders,
    }
  }

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
