# This class installs and configures the mailadmin interface
class profile::mailadmin {
  require ::profile::mailadmin::dependencies
  include ::profile::mailadmin::install
  include ::profile::mailadmin::configure
  include ::profile::mailadmin::web
}
