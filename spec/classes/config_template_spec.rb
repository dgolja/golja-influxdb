require 'spec_helper'

describe 'influxdb::server', :type => :class do

  default = {
    'log_level' => 'warn',
    'ssl_path' => 'undef',
    'ssl_port' => 8084,
    'enable_ssl' => 'undef',
    'config_file' => '/opt/influxdb/current/config.toml',
    'ensure' => 'present',
    'conf_template' =>'influxdb/config.toml.erb',
    'influxdb_user' => 'influxdb',
    'influxdb_group' => 'influxdb',
    'raft_port' => 8090,
    'raft_log_dir' => '/opt/influxdb/shared/data/raft',
    'storage_dir' => '/opt/influxdb/shared/data/db',
    'storage_write_buffer_size' => 10000,
    'default_engine' => 'rocksdb',
    'max_open_shards' => 0,
    'point_batch_size' => 100,
    'write_batch_size' => 5000000,
    'retention_sweep_period' => '10m',
    'override_storage_engines' => {},
    'seed_servers' => 'undef',
    'protobuf_port' => 8099,
    'protobuf_timeout' => '2s',
    'protobuf_heartbeat' => '200ms',
    'protobuf_min_backoff' => '1s',
    'protobuf_max_backoff' => '10s',
    'cluster_write_buffer_size' => 1000,
    'cluster_max_response_buffer_size' => 100,
    'concurrent_shard_query_limit' => 3,
    'wal_dir' => '/opt/influxdb/shared/data/wal',
    'wal_flush_after' => 1000,
    'wal_bookmark_after' => 1000,
    'wal_index_after' => 1000,
    'wal_requests_per_logfile' => 10000
  }

  context 'normal Ubuntu entry' do
    let :facts do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Ubuntu',
        :operatingsystemrelease => '12.04',
      }
    end
    it { is_expected.to contain_file('/opt/influxdb/current/config.toml') }
    it { is_expected.to contain_file('/opt/influxdb/current/config.toml').with_content(/bind-address = "0.0.0.0"/) }
    it { is_expected.to contain_file('/opt/influxdb/current/config.toml').with_content(/map-size = "100g"/) }
  end

  context 'override options for lmdb' do
    let (:params) {{ :override_storage_engines => { 'storage.engines.lmdb' => { 'map-size' => '200g' } } }}
    let :facts do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Ubuntu',
        :operatingsystemrelease => '12.04',
      }
    end
    it { is_expected.to contain_file('/opt/influxdb/current/config.toml') }
    it { is_expected.to contain_file('/opt/influxdb/current/config.toml').with_content(/bind-address = "0.0.0.0"/) }
    it { is_expected.to contain_file('/opt/influxdb/current/config.toml').with_content(/map-size = "200g"/) }
  end

end
