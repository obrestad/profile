class profile::samba {
  $samba_eigil_pass = hiera('profile::user::eigil::samba::pass')

  class {'samba::server':
    workgroup     => 'rothaugane',
    server_string => 'Antoccino',
    interfaces    => 'eth0 lo',
    security      => 'user'
  }

  samba::server::user { 'eigil':
    password => $samba_eigil_pass,
  }

  samba::server::share {'archive':
    comment              => 'Archived stuff',
    path                 => '/srv/archive',
    guest_only           => false,
    guest_ok             => false,
    guest_account        => 'nobody',
    browsable            => true,
    force_group          => 'users',
  }
}
