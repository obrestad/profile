class profile::samba {
  $samba_eigil_pass = hiera('profile::user::eigil::samba::pass')

  class {'samba::server':
    workgroup     => 'rothaugane',
    server_string => 'Antoccino',
    interfaces    => 'eth0 lo',
    security      => 'share'
  }

  samba::server::user { 'eigil':
    password => $samba_eigil_pass,
  }

  samba::server::share {'archive':
    comment              => 'Archived stuff',
    path                 => '/srv/archive',
    guest_only           => false,
    guest_ok             => flase,
    guest_account        => 'nobody',
    browsable            => true,
    create_mask          => 0777,
    force_create_mask    => 0777,
    directory_mask       => 0777,
    force_directory_mask => 0777,
    force_group          => 'users',
  }
}
