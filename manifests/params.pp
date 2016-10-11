class influxdb::params {
  $version                                      = 'installed'
  $ensure                                       = 'present'
  $service_enabled                              = true
  $conf_template                                = 'influxdb/influxdb.conf.erb'
  $config_file                                  = '/etc/influxdb/influxdb.conf'

  $influxdb_stderr_log                          = '/var/log/influxdb/influxd.log'
  $influxdb_stdout_log                          = '/dev/null'
  $influxd_opts                                 = undef
  $manage_install                               = true

  $reporting_disabled                           = false

  $meta_dir                                     = '/var/lib/influxdb/meta'
  $meta_bind_address                            = ':8088'
  $meta_http_bind_address                       = ':8091'
  $retention_autocreate                         = true
  $election_timeout                             = '1s'
  $heartbeat_timeout                            = '1s'
  $leader_lease_timeout                         = '500ms'
  $commit_timeout                               = '50ms'
  $cluster_tracing                              = false

  $data_enabled                                 = true
  $data_dir                                     = '/var/lib/influxdb/data'
  $wal_dir                                      = '/var/lib/influxdb/wal'
  $wal_logging_enabled                          = true
  $trace_logging_enabled                        = false
  $cache_max_memory_size                        = undef
  $cache_snapshot_memory_size                   = undef
  $cache_snapshot_write_cold_duration           = undef
  $compact_min_file_count                       = undef
  $compact_full_write_cold_duration             = undef
  $max_points_per_block                         = undef
  $max_series_per_database                      = 1000000

  $hinted_handoff_enabled                       = true
  $hinted_handoff_dir                           = '/var/lib/influxdb/hh'
  $hinted_handoff_max_size                      = 1073741824
  $hinted_handoff_max_age                       = '168h'
  $hinted_handoff_retry_rate_limit              = 0
  $hinted_handoff_retry_interval                = '1s'
  $hinted_handoff_retry_max_interval            = '1m'
  $hinted_handoff_purge_interval                = '1h'

  $cluster_write_timeout                        = '10s'
  $query_timeout                                = '0'
  $log_queries_after                            = '0'
  $max_select_point                             = 0
  $max_select_series                            = 0
  $max_select_buckets                           = 0

  $retention_enabled                            = true
  $retention_check_interval                     = '30m'

  $shard_precreation_enabled                    = true
  $shard_precreation_check_interval             = '10m'
  $shard_precreation_advance_period             = '30m'

  $monitoring_enabled                           = true
  $monitoring_database                          = '_internal'
  $monitoring_write_interval                    = '10s'

  $admin_enabled                                = true
  $admin_bind_address                           = ':8083'
  $admin_https_enabled                          = false
  $admin_https_certificate                      = '/etc/ssl/influxdb.pem'

  $http_enabled                                 = true
  $http_bind_address                            = ':8086'
  $http_auth_enabled                            = false
  $http_log_enabled                             = true
  $http_write_tracing                           = false
  $http_pprof_enabled                           = false
  $http_https_enabled                           = false
  $http_https_certificate                       = '/etc/ssl/influxdb.pem'
  $http_https_private_key                       = undef
  $http_max_row_limit                           = 10000
  $http_realm                                   = 'InfluxDB'

  $subscriber_enabled                           = true
  $subscriber_http_timeout                      = '30s'

  $graphite_options                             = undef
  $collectd_options                             = undef
  $opentsdb_options                             = undef
  $udp_options                                  = undef

  $continuous_queries_enabled                   = true
  $continuous_queries_log_enabled               = true
  $continuous_queries_run_interval              = undef
  $service_provider                             = undef

  $influxdb_user                                = 'influxdb'
  $influxdb_group                               = 'influxdb'
  case $::osfamily {
    'Debian', 'RedHat', 'Amazon': {
      $manage_repos = true
    }
    'Archlinux': {
      $manage_repos = false
    }
    default: {
      fail("Unsupported managed repository for osfamily: ${::osfamily}, operatingsystem: ${::operatingsystem},\
      module ${module_name} currently only supports managing repos for osfamily RedHat, Debian and Archlinux")
    }
  }

}
