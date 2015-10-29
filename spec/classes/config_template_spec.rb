require 'spec_helper'

describe 'influxdb::server', :type => :class do

  default = {
    'bind_address' => ':8088',
    'retention_autocreate' => true,
    'election_timeout' => '1s',
    'heartbeat_timeout' => '1s',
    'leader_lease_timeout' => '500ms',
    'commit_timeout' => '50ms',
    'data_dir' => '/var/opt/influxdb/data',
    'max_wal_size' => 104857600,
    'wal_flush_interval' => '10m',
    'wal_partition_flush_delay' => '2s',
    'shard_writer_timeout' => '5s',
    'cluster_write_timeout' => '5s',
    'retention_enabled' => true,
    'retention_check_interval' => '10m',
    'admin_enabled' => true,
    'admin_bind_address' => ':8083',
    'admin_https_enabled' => false,
    'admin_https_certificate' => '/etc/ssl/influxdb.pem',
    'http_enabled' => true,
    'http_bind_address' => ':8086',
    'http_auth_enabled' => false,
    'http_log_enabled' => true,
    'http_write_tracing' => false,
    'http_pprof_enabled' => false,
    'http_https_enabled' => false,
    'http_https_certificate' => '/etc/ssl/influxdb.pem',
    'graphite_enabled' => false,
    'graphite_bind_address' => ':2003',
    'graphite_protocol' => 'tcp',
    'graphite_consistency_level' => 'one',
    'graphite_separator' => '.',
    'graphite_tags' => [],
    'graphite_templates' => [],
    'graphite_ignore_unnamed' => true,
    'collectd_enabled' => false,
    'collectd_bind_address' => 'undef',
    'collectd_database' => 'undef',
    'collectd_typesdb' => 'undef',
    'opentsdb_enabled' => false,
    'opentsdb_bind_address' => 'undef',
    'opentsdb_database' => 'undef',
    'opentsdb_retention_policy' => 'undef',
    'udp_options' => 'undef',
    'monitoring_enabled' => true,
    'monitoring_write_interval' => '24h',
    'continuous_queries_enabled' => true,
    'continuous_queries_recompute_previous_n' => 2,
    'continuous_queries_recompute_no_older_than' => '10m',
    'continuous_queries_compute_runs_per_interval' => 10,
    'continuous_queries_compute_no_more_than' => '2m',
    'hinted_handoff_enabled' => true,
    'hinted_handoff_dir' => '/var/opt/influxdb/hh',
    'hinted_handoff_max_size' => 1073741824,
    'hinted_handoff_max_age' => '168h',
    'hinted_handoff_retry_rate_limit' => 0,
    'hinted_handoff_retry_interval' => '1s',
    'reporting_disabled' => false,
    'conf_template' => 'influxdb/influxdb.conf.erb',
    'config_file' => '/etc/opt/influxdb/influxdb.conf',
    'enable_snapshot' => false,
    'influxdb_stderr_log' => '/var/log/influxdb/influxd.log',
    'influxdb_stdout_log' => '/dev/null'

  }

  context 'normal Ubuntu entry' do
    let :facts do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Ubuntu',
        :operatingsystemrelease => '12.04',
      }
    end
    it { is_expected.to contain_file('/etc/opt/influxdb/influxdb.conf') }
    it { is_expected.to contain_file('/etc/opt/influxdb/influxdb.conf').with_content(/bind-address = ":8088"/) }
    it { is_expected.to contain_file('/etc/opt/influxdb/influxdb.conf').with_content(/commit-timeout = "50ms"/) }
  end

  context 'override options for lmdb' do
    let (:params) {{ :retention_check_interval => '20m' }}
    let :facts do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Ubuntu',
        :operatingsystemrelease => '12.04',
      }
    end
    it { is_expected.to contain_file('/etc/opt/influxdb/influxdb.conf') }
    it { is_expected.to contain_file('/etc/opt/influxdb/influxdb.conf').with_content(/bind-address = ":8088"/) }
    it { is_expected.to contain_file('/etc/opt/influxdb/influxdb.conf').with_content(/check-interval = "20m"/) }
  end

  context 'add 0.9.3 specific wal options' do
    let (:params) {{ :version => '0.9.3' }}
    let :facts do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Ubuntu',
        :operatingsystemrelease => '12.04',
      }
    end
    it { is_expected.to contain_file('/etc/opt/influxdb/influxdb.conf') }
    it { is_expected.to contain_file('/etc/opt/influxdb/influxdb.conf').with_content(/wal-dir = "\/var\/opt\/influxdb\/wal"/) }
  end

  context 'without 0.9.3 options if version installed < 0.9.3' do
    let (:params) {{ :version => '0.9.2' }}
    let :facts do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Ubuntu',
        :operatingsystemrelease => '12.04',
      }
    end
    it { is_expected.to contain_file('/etc/opt/influxdb/influxdb.conf') }
    it { is_expected.to contain_file('/etc/opt/influxdb/influxdb.conf').without_content(/wal-dir = "\/var\/opt\/influxdb\/wal"/) }
  end

end
