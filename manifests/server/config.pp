class influxdb::server::config {
  $log_level                        = $influxdb::server::log_level
  $ssl_path                         = $influxdb::server::ssl_path
  $ssl_port                         = $influxdb::server::ssl_port
  $enable_ssl                       = $influxdb::server::enable_ssl
  $config_file                      = $influxdb::server::config_file
  $ensure                           = $influxdb::server::ensure
  $conf_template                    = $influxdb::server::conf_template
  $influxdb_user                    = $influxdb::server::influxdb_user
  $influxdb_group                   = $influxdb::server::influxdb_group
  $raft_port                        = $influxdb::server::raft_port
  $raft_log_dir                     = $influxdb::server::raft_log_dir
  $storage_dir                      = $influxdb::server::storage_dir
  $storage_write_buffer_size        = $influxdb::server::storage_write_buffer_size
  $default_engine                   = $influxdb::server::default_engine
  $max_open_shards                  = $influxdb::server::max_open_shards
  $point_batch_size                 = $influxdb::server::point_batch_size
  $max_open_shards                  = $influxdb::server::max_open_shards
  $point_batch_size                 = $influxdb::server::point_batch_size
  $write_batch_size                 = $influxdb::server::write_batch_size
  $retention_sweep_period           = $influxdb::server::retention_sweep_period
  $storage_engines_options          = $influxdb::server::storage_engines_options
  $seed_servers                     = $influxdb::server::seed_servers
  $protobuf_port                    = $influxdb::server::protobuf_port
  $protobuf_timeout                 = $influxdb::server::protobuf_timeout
  $protobuf_heartbeat               = $influxdb::server::protobuf_heartbeat
  $protobuf_min_backoff             = $influxdb::server::protobuf_min_backoff
  $protobuf_max_backoff             = $influxdb::server::protobuf_max_backoff
  $cluster_write_buffer_size        = $influxdb::server::cluster_write_buffer_size
  $cluster_max_response_buffer_size = $influxdb::server::cluster_max_response_buffer_size
  $concurrent_shard_query_limit     = $influxdb::server::concurrent_shard_query_limit
  $wal_dir                          = $influxdb::server::wal_dir
  $wal_flush_after                  = $influxdb::server::wal_flush_after
  $wal_bookmark_after               = $influxdb::server::wal_bookmark_after
  $wal_index_after                  = $influxdb::server::wal_index_after
  $wal_requests_per_logfile         = $influxdb::server::wal_requests_per_logfile

  if !($log_level in ['info', 'debug','warn','error']) {
    fail('log level must be info,debug,warn or error')
  }

  if $enable_ssl and $ssl_path == undef {
    fail('If SSL is enabled you need to define parameter ssl_path')
  }

  file { $config_file:
    ensure  => $ensure,
    content => template($conf_template),
    owner   => $influxdb_user,
    group   => $influxdb_group,
    mode    => '0644',
  }

}