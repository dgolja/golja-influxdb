class influxdb::server (
  $version = $influxdb::params::version
) inherits influxdb::params {

  anchor { 'influxdb::server::start': }->
  class { 'influxdb::server::install': }->
  class { "influxdb::server::config": }->
  class { "influxdb::server::service": }->
  anchor { "influxdb::server::end": }

}