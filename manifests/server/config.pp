# add more stdlib input validation
class influxdb::server::config {
  $version                                      = $influxdb::server::version
  $ensure                                       = $influxdb::server::ensure
  $service_enabled                              = $influxdb::server::service_enabled
  $conf_template                                = $influxdb::server::conf_template
  $config_file                                  = $influxdb::server::config_file

  $influxdb_user                                = $influxdb::server::influxdb_user
  $influxdb_group                               = $influxdb::server::influxdb_group
  $influxdb_stderr_log                          = $influxdb::server::influxdb_stderr_log
  $influxdb_stdout_log                          = $influxdb::server::influxdb_stdout_log
  $influxd_opts                                 = $influxdb::server::influxd_opts
  $manage_install                               = $influxdb::server::manage_install
  $manage_repos                                 = $influxdb::server::manage_repos

  $reporting_disabled                           = $influxdb::server::reporting_disabled

  $meta_dir                                     = $influxdb::server::meta_dir
  $meta_bind_address                            = $influxdb::server::meta_bind_address
  $meta_http_bind_address                       = $influxdb::server::meta_http_bind_address
  $retention_autocreate                         = $influxdb::server::retention_autocreate
  $election_timeout                             = $influxdb::server::election_timeout
  $heartbeat_timeout                            = $influxdb::server::heartbeat_timeout
  $leader_lease_timeout                         = $influxdb::server::leader_lease_timeout
  $commit_timeout                               = $influxdb::server::commit_timeout
  $cluster_tracing                              = $influxdb::server::cluster_tracing

  $data_enabled                                 = $influxdb::server::data_enabled
  $data_dir                                     = $influxdb::server::data_dir
  $wal_dir                                      = $influxdb::server::wal_dir
  $wal_logging_enabled                          = $influxdb::server::wal_logging_enabled
  $trace_logging_enabled                        = $influxdb::server::trace_logging_enabled
  $cache_max_memory_size                        = $influxdb::server::cache_max_memory_size
  $cache_snapshot_memory_size                   = $influxdb::server::cache_snapshot_memory_size
  $cache_snapshot_write_cold_duration           = $influxdb::server::cache_snapshot_write_cold_duration
  $compact_min_file_count                       = $influxdb::server::compact_min_file_count
  $compact_full_write_cold_duration             = $influxdb::server::compact_full_write_cold_duration
  $max_points_per_block                         = $influxdb::server::max_points_per_block
  $max_series_per_database                      = $influxdb::server::max_series_per_database

  $hinted_handoff_enabled                       = $influxdb::server::hinted_handoff_enabled
  $hinted_handoff_dir                           = $influxdb::server::hinted_handoff_dir
  $hinted_handoff_max_size                      = $influxdb::server::hinted_handoff_max_size
  $hinted_handoff_max_age                       = $influxdb::server::hinted_handoff_max_age
  $hinted_handoff_retry_rate_limit              = $influxdb::server::hinted_handoff_retry_rate_limit
  $hinted_handoff_retry_interval                = $influxdb::server::hinted_handoff_retry_interval
  $hinted_handoff_retry_max_interval            = $influxdb::server::hinted_handoff_retry_max_interval
  $hinted_handoff_purge_interval                = $influxdb::server::hinted_handoff_purge_interval

  $cluster_write_timeout                        = $influxdb::server::cluster_write_timeout
  $query_timeout                                = $influxdb::server::query_timeout
  $log_queries_after                            = $influxdb::server::log_queries_after
  $max_select_point                             = $influxdb::server::max_select_point
  $max_select_series                            = $influxdb::server::max_select_series
  $max_select_buckets                           = $influxdb::server::max_select_buckets

  $retention_enabled                            = $influxdb::server::retention_enabled
  $retention_check_interval                     = $influxdb::server::retention_check_interval

  $shard_precreation_enabled                    = $influxdb::server::shard_precreation_enabled
  $shard_precreation_check_interval             = $influxdb::server::shard_precreation_check_interval
  $shard_precreation_advance_period             = $influxdb::server::shard_precreation_advance_period

  $monitoring_enabled                           = $influxdb::server::monitoring_enabled
  $monitoring_database                          = $influxdb::server::monitoring_database
  $monitoring_write_interval                    = $influxdb::server::monitoring_write_interval

  $admin_enabled                                = $influxdb::server::admin_enabled
  $admin_bind_address                           = $influxdb::server::admin_bind_address
  $admin_https_enabled                          = $influxdb::server::admin_https_enabled
  $admin_https_certificate                      = $influxdb::server::admin_https_certificate

  $http_enabled                                 = $influxdb::server::http_enabled
  $http_bind_address                            = $influxdb::server::http_bind_address
  $http_auth_enabled                            = $influxdb::server::http_auth_enabled
  $http_log_enabled                             = $influxdb::server::http_log_enabled
  $http_write_tracing                           = $influxdb::server::http_write_tracing
  $http_pprof_enabled                           = $influxdb::server::http_pprof_enabled
  $http_https_enabled                           = $influxdb::server::http_https_enabled
  $http_https_certificate                       = $influxdb::server::http_https_certificate
  $http_https_private_key                       = $influxdb::server::http_https_private_key
  $http_max_row_limit                           = $influxdb::server::http_max_row_limit
  $http_realm                                   = $influxdb::server::http_realm

  $subscriber_enabled                            = $influxdb::server::subscriber_enabled
  $subscriber_http_timeout                       = $influxdb::server::subscriber_http_timeout

  $graphite_options                             = $influxdb::server::graphite_options
  $collectd_options                             = $influxdb::server::collectd_options
  $opentsdb_options                             = $influxdb::server::opentsdb_options
  $udp_options                                  = $influxdb::server::udp_options

  $continuous_queries_enabled                   = $influxdb::server::continuous_queries_enabled
  $continuous_queries_log_enabled               = $influxdb::server::continuous_queries_log_enabled
  $continuous_queries_run_interval              = $influxdb::server::continuous_queries_run_interval

  file { $config_file:
    ensure  => $ensure,
    content => template($conf_template),
    owner   => $influxdb_user,
    group   => $influxdb_group,
    mode    => '0644',
    notify  => Service['influxdb'],
  }

  file { '/etc/default/influxdb':
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('influxdb/influxdb_default.erb'),
    notify  => Service['influxdb'],
  }

}
