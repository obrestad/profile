# Sets up the monitoring server
class profile::monitoring {
  include ::profile::monitoring::chronograf
  include ::profile::monitoring::influxdb
}
