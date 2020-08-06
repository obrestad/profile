# Configures default users/groups
class profile::users {
  require ::profile::users::groups
  include ::profile::users::root
}
