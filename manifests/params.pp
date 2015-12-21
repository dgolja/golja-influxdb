class influxdb::params {
  $version                                      = '0.9.4'
  $ensure                                       = 'present'
  $service_enabled                              = true
  $bind_address                                 = ':8088'
  $retention_autocreate                         = true
  $election_timeout                             = '1s'
  $heartbeat_timeout                            = '1s'
  $leader_lease_timeout                         = '500ms'
  $commit_timeout                               = '50ms'
  $data_dir                                     = '/var/opt/influxdb/data'
  $wal_dir                                      = '/var/opt/influxdb/wal'
  $meta_dir                                     = '/var/opt/influxdb/meta'
  $wal_enable_logging                           = true
  $wal_ready_series_size                        = 25600
  $wal_compaction_threshold                     = '0.6'
  $wal_max_series_size                          = 2097152
  $wal_flush_cold_interval                      = '10m'
  $wal_partition_size_threshold                 = 20971520
  $max_wal_size                                 = 104857600
  $wal_flush_interval                           = '10m'
  $wal_partition_flush_delay                    = '2s'
  $shard_writer_timeout                         = '5s'
  $cluster_write_timeout                        = '5s'
  $retention_enabled                            = true
  $retention_check_interval                     = '10m'
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
  $graphite_enabled                             = false
  $graphite_bind_address                        = ':2003'
  $graphite_protocol                            = 'tcp'
  $graphite_consistency_level                   = 'one'
  $graphite_separator                           = '.'
  $graphite_tags                                = []
  $graphite_templates                           = []
  $graphite_ignore_unnamed                      = true
  $collectd_enabled                             = false
  $collectd_bind_address                        = undef
  $collectd_database                            = undef
  $collectd_typesdb                             = undef
  $opentsdb_enabled                             = false
  $opentsdb_bind_address                        = undef
  $opentsdb_database                            = undef
  $opentsdb_retention_policy                    = undef
  $udp_options                                  = undef
  $monitoring_enabled                           = true
  $monitoring_write_interval                    = '24h'
  $continuous_queries_enabled                   = true
  $continuous_queries_recompute_previous_n      = 2
  $continuous_queries_recompute_no_older_than   = '10m'
  $continuous_queries_compute_runs_per_interval = 10
  $continuous_queries_compute_no_more_than      = '2m'
  $hinted_handoff_enabled                       = true
  $hinted_handoff_dir                           = '/var/opt/influxdb/hh'
  $hinted_handoff_max_size                      = 1073741824
  $hinted_handoff_max_age                       = '168h'
  $hinted_handoff_retry_rate_limit              = 0
  $hinted_handoff_retry_interval                = '1s'
  $reporting_disabled                           = false
  $conf_template                                = 'influxdb/influxdb.conf.erb'
  $config_file                                  = '/etc/opt/influxdb/influxdb.conf'
  $enable_snapshot                              = false
  $influxdb_stderr_log                          = '/var/log/influxdb/influxd.log'
  $influxdb_stdout_log                          = '/dev/null'
  $influxd_opts                                 = undef
  $manage_install                               = true

  case $::osfamily {
    'Debian': {
      $package_provider = 'dpkg'
      $package_source   = 'http://s3.amazonaws.com/influxdb/influxdb_'
      $influxdb_user    = 'influxdb'
      $influxdb_group   = 'influxdb'

      $package_suffix = $::architecture ? {
          /64/    => '_amd64.deb',
          default => '_i386.deb',
      }

      if $::operatingsystem == 'Ubuntu' {
        $service_provider = 'upstart'
      } else {
        $service_provider = undef
      }
    }
    'RedHat', 'Amazon': {
      $package_provider = 'rpm'
      $package_source = 'http://s3.amazonaws.com/influxdb/influxdb-'
      $influxdb_user    = 'influxdb'
      $influxdb_group   = 'influxdb'

      $package_suffix = $::architecture ? {
          /64/    => '-1.x86_64.rpm',
          default => '-1.i686.rpm',
        }
    }
  }

}
