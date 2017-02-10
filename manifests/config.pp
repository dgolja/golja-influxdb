#
class influxdb::config(
  $conf                      = '/tmp/influxdb::config',
  $conf_owner                = 'root',
  $conf_group                = 'root',
  $conf_mode                 = '0644',
  $conf_template             = $influxdb::conf_template,

  $startup_conf              = $influxdb::startup_conf,
  $startup_conf_template     = $influxdb::startup_conf_template,

  $global_config             = $influxdb::global_config,
  $meta_config               = $influxdb::meta_config,
  $data_config               = $influxdb::data_config,
  $coordinator_config        = $influxdb::coordinator_config,
  $retention_config          = $influxdb::retention_config,
  $shard_precreation_config  = $influxdb::shard_precreation_config,
  $monitor_config            = $influxdb::monitor_config,
  $admin_config              = $influxdb::admin_config,
  $http_config               = $influxdb::http_config,
  $subscriber_config         = $influxdb::subscriber_config,
  $graphite_config           = $influxdb::graphite_config,
  $collectd_config           = $influxdb::collectd_config,
  $opentsdb_config           = $influxdb::opentsdb_config,
  $udp_config                = $influxdb::udp_config,
  $continuous_queries_config = $influxdb::continuous_queries_config,
  $hinted_handoff_config     = $influxdb::hinted_handoff_config,
) {

  file { $conf:
    ensure  => 'file',
    owner   => $conf_owner,
    group   => $conf_group,
    mode    => $conf_mode,
    content => template($conf_template),
  }

  if $startup_conf {

    file { $startup_conf:
      ensure  => 'file',
      owner   => $conf_owner,
      group   => $conf_group,
      mode    => $conf_mode,
      content => template($startup_conf_template),
    }

  }

}
