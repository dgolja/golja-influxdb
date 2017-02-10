# == Class: influxdb
#
#
# === Author
#
# Dejan Golja <dejan@golja.org>
#
class influxdb(
  $version                            = $influxdb::params::version,
  $ensure                             = $influxdb::params::ensure,
  $service_enabled                    = $influxdb::params::service_enabled,
  $service_ensure                     = $influxdb::params::service_ensure,
  $conf_template                      = $influxdb::params::conf_template,
  $config_file                        = $influxdb::params::config_file,

  $influxdb_stderr_log                = $influxdb::params::influxdb_stderr_log,
  $influxdb_stdout_log                = $influxdb::params::influxdb_stdout_log,
  $influxd_opts                       = $influxdb::params::influxd_opts,
  $manage_install                     = $influxdb::params::manage_install,
  $manage_repos                       = $influxdb::params::manage_repos,
) inherits influxdb::params {

  anchor { 'influxdb::tart': }   ->
  class { 'influxdb::install': } ->
  class { 'influxdb::config': }  ~>
  class { 'influxdb::service': } ->
  anchor { 'influxdb::end': }

}
