class influxdb::params {
  $ensure                                       = 'present'
  $registration_enabled                         = false
  $registration_url                             = 'https://enterprise.influxdata.com'
  $registration_token                           = undef
  $service_enabled                              = true
  $bind_address                                 = ':8088'
  $retention_autocreate                         = true
  $election_timeout                             = '1s'
  $heartbeat_timeout                            = '1s'
  $leader_lease_timeout                         = '500ms'
  $commit_timeout                               = '50ms'
  $cluster_tracing                              = false
  $raft_promotion_enabled                       = true
  $data_dir                                     = '/var/lib/influxdb/data'
  $data_engine                                  = undef
  $wal_dir                                      = '/var/lib/influxdb/wal'
  $meta_dir                                     = '/var/lib/influxdb/meta'
  $wal_enable_logging                           = true
  $wal_ready_series_size                        = 25600
  $wal_compaction_threshold                     = '0.6'
  $wal_max_series_size                          = 2097152
  $wal_flush_cold_interval                      = '10m'
  $wal_partition_size_threshold                 = 20971520
  $max_wal_size                                 = 104857600
  $wal_flush_interval                           = '10m'
  $wal_partition_flush_delay                    = '2s'
  $query_log_enabled                            = false
  $tsm_cache_max_memory_size                    = 524288000
  $tsm_cache_snapshot_memory_size               = 26214400
  $tsm_cache_snapshot_write_cold_duration       = '1h'
  $tsm_compact_min_file_count                   = 3
  $tsm_compact_full_write_cold_duration         = '24h'
  $tsm_max_points_per_block                     = 1000
  $shard_writer_timeout                         = '5s'
  $cluster_write_timeout                        = '5s'
  $retention_enabled                            = true
  $retention_check_interval                     = '10m'
  $shard_precreation_enabled                    = true
  $shard_precreation_check_interval             = '10m'
  $shard_precreation_advance_period             = '30m'
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
  $graphite_options                             = undef
  $collectd_options                             = undef
  $opentsdb_options                             = undef
  $udp_options                                  = undef
  $monitoring_enabled                           = true
  $monitoring_write_interval                    = '24h'
  $continuous_queries_enabled                   = true
  $continuous_queries_recompute_previous_n      = 2
  $continuous_queries_recompute_no_older_than   = '10m'
  $continuous_queries_compute_runs_per_interval = 10
  $continuous_queries_compute_no_more_than      = '2m'
  $hinted_handoff_enabled                       = true
  $hinted_handoff_dir                           = '/var/lib/influxdb/hh'
  $hinted_handoff_max_size                      = 1073741824
  $hinted_handoff_max_age                       = '168h'
  $hinted_handoff_retry_rate_limit              = 0
  $hinted_handoff_retry_interval                = '1s'
  $hinted_handoff_retry_max_interval            = '1m'
  $hinted_handoff_purge_interval                = '1h'
  $reporting_disabled                           = false
  $conf_template                                = 'influxdb/influxdb.conf.erb'
  $config_file                                  = '/etc/influxdb/influxdb.conf'
  $enable_snapshot                              = false
  $influxdb_stderr_log                          = '/var/log/influxdb/influxd.log'
  $influxdb_stdout_log                          = '/dev/null'
  $influxd_opts                                 = undef
  $manage_install                               = true
  $repo_stage                                   = 'main'

  case $::osfamily {
    'Debian': {
      $influxdb_user    = 'influxdb'
      $influxdb_group   = 'influxdb'


      if $::operatingsystem == 'Ubuntu' {
        $service_provider = 'upstart'
      } else {
        $service_provider = undef
      }
    }
    'RedHat', 'Amazon': {
      $influxdb_user    = 'influxdb'
      $influxdb_group   = 'influxdb'
    }
    default: {
      fail("Unsupported managed repository for osfamily: ${::osfamily}, operatingsystem: ${::operatingsystem}, module ${module_name} currently only supports managing repos for osfamily RedHat and Debian")
    }
  }

}
