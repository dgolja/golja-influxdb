#
class influxdb::config(
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

  $conf = '/tmp/influxdb.conf'

  file { $conf:
    ensure  => 'file',
    mode    => '0644',
    content => template($::influxdb::params::conf_template),
  }

}
