class influxdb::server (
  $ensure                           = $influxdb::params::ensure,
  $version                          = $influxdb::params::version,
  $config_file                      = $influxdb::params::config_file,
  $service_provider                 = $influxdb::params::service_provider,
  $service_enabled                  = $influxdb::params::service_enabled,
  $package_ensure                   = $influxdb::params::package_ensure,
  $package_provider                 = $influxdb::params::package_provider,
  $bind_address                     = $influxdb::params::bind_address,
  $reporting_disabled               = $influxdb::params::reporting_disabled,
  $log_level                        = $influxdb::params::log_level,
  $admin_port                       = $influxdb::params::admin_port,
  $disable_api                      = $influxdb::params::disable_api,
  $api_port                         = $influxdb::params::api_port,
  $enable_ssl                       = $influxdb::params::enable_ssl, #change of name ?
  $ssl_port                         = $influxdb::params::ssl_port,
  $ssl_path                         = undef,
  $read_timeout                     = $influxdb::params::read_timeout,
  $input_plugins                    = {},
  $conf_template                    = $influxdb::params::conf_template,
  $influxdb_user                    = $influxdb::params::influxdb_user,
  $influxdb_group                   = $influxdb::params::influxdb_group,
  $raft_port                        = $influxdb::params::raft_port,
  $raft_log_dir                     = $influxdb::params::raft_log_dir,
  $storage_dir                      = $influxdb::params::storage_dir,
  $storage_write_buffer_size        = $influxdb::params::storage_write_buffer_size,
  $default_engine                   = $influxdb::params::default_engine,
  $max_open_shards                  = $influxdb::params::max_open_shards,
  $point_batch_size                 = $influxdb::params::point_batch_size,
  $write_batch_size                 = $influxdb::params::write_batch_size,
  $retention_sweep_period           = $influxdb::params::retention_sweep_period,
  $override_storage_engines         = {},
  $seed_servers                     = undef,
  $protobuf_port                    = $influxdb::params::protobuf_port,
  $protobuf_timeout                 = $influxdb::params::protobuf_timeout,
  $protobuf_heartbeat               = $influxdb::params::protobuf_heartbeat,
  $protobuf_min_backoff             = $influxdb::params::protobuf_min_backoff,
  $protobuf_max_backoff             = $influxdb::params::protobuf_max_backoff,
  $cluster_write_buffer_size        = $influxdb::params::cluster_write_buffer_size,
  $cluster_max_response_buffer_size = $influxdb::params::cluster_max_response_buffer_size,
  $concurrent_shard_query_limit     = $influxdb::params::concurrent_shard_query_limit,
  $wal_dir                          = $influxdb::params::wal_dir,
  $wal_flush_after                  = $influxdb::params::wal_flush_after, 
  $wal_bookmark_after               = $influxdb::params::wal_bookmark_after,
  $wal_index_after                  = $influxdb::params::wal_index_after,
  $wal_requests_per_logfile         = $influxdb::params::wal_requests_per_logfile,
) inherits influxdb::params {

  $storage_engines_options = influxdb_deepmerge(influxdb::params::default_storage_engines, $override_storage_engines)

  anchor { 'influxdb::server::start': }->
  class { 'influxdb::server::install': }->
  class { "influxdb::server::config": }->
  class { "influxdb::server::service": }->
  anchor { "influxdb::server::end": }

}