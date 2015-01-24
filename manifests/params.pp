class influxdb::params {
  $version                          = 'latest'
  $package_ensure                   = 'present'
  $ensure                           = 'present'
  $service_enabled                  = true
  $bind_address                     = '0.0.0.0'
  $reporting_disabled               = false
  $log_level                        = 'info'
  $admin_port                       = 8083
  $disable_api                      = false
  $api_port                         = 8086
  $enable_ssl                       = false
  $ssl_port                         = 8084
  $read_timeout                     = '5s'
  $conf_template                    = 'influxdb/config.toml.erb'
  $raft_port                        = 8090
  $storage_write_buffer_size        = 10000
  $default_engine                   = 'rocksdb'
  $max_open_shards                  = 0
  $point_batch_size                 = 100
  $write_batch_size                 = 5000000
  $retention_sweep_period           = '10m'
  $leveldb_max_open_files           = 1000
  $leveldb_lru_cache_size           = '200m'
  $rocksdb_max_open_files           = 1000
  $rocksdb_lru_cache_size           = '200m'
  $lmdb_map_size                    = '100g'
  $protobuf_port                    = 8099
  $protobuf_timeout                 = '2s'
  $protobuf_heartbeat               = '200ms'
  $protobuf_min_backoff             = '1s'
  $protobuf_max_backoff             = '10s'
  $cluster_write_buffer_size        = 1000
  $cluster_max_response_buffer_size = 100
  $concurrent_shard_query_limit     = 10
  $wal_flush_after                  = 1000
  $wal_bookmark_after               = 1000
  $wal_index_after                  = 1000
  $wal_requests_per_logfile         = 10000
  
  $package_source = 'http://s3.amazonaws.com/influxdb/influxdb_'

  case $::osfamily {
    'Debian': {
      $package_provider = 'dpkg'
      $config_file      = '/opt/influxdb/current/config.toml'
      $influxdb_user    = 'influxdb'
      $influxdb_group   = 'influxdb'
      $raft_log_dir     = '/opt/influxdb/shared/data/raft'
      $storage_dir      = '/opt/influxdb/shared/data/db'
      $wal_dir          = '/opt/influxdb/shared/data/wal'
      
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

      $package_suffix = $::architecture ? {
          /64/    => '-1.x86_64.rpm',
          default => '-1.i686.rpm',
        }
    }
  }
  
  # default value for the storage.engines
  $default_storage_engines = {
    'storage.engines.leveldb' => {
      'max-open-files'        => $leveldb_max_open_files,
      'lru-cache-size'        => $leveldb_lru_cache_size,
    },
    'storage.engines.rocksdb' => {
      'max-open-files'        => $rocksdb_max_open_files,
      'lru-cache-size'        => $rocksdb_lru_cache_size,
    },
    'storage.engines.lmdb'    => {
      'map-size'              => $lmdb_map_size,
    },
  }

}