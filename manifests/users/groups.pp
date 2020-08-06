# Configures default groups
class profile::users::groups {
  group { 'users':
    ensure => present,
    gid    => 700,
  }
  group { 'admins':
    ensure => present,
    gid    => 701,
  }
  group { 'service':
    ensure => present,
    gid    => 702,
  }
}
