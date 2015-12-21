require 'spec_helper'

describe 'influxdb::server', :type => :class do
  context 'override options for lmdb' do
    let (:params) {{ :influxd_opts => 'OPTIONS' }}
    let :facts do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Ubuntu',
        :operatingsystemrelease => '12.04',
      }
    end
    it { is_expected.to contain_file('/etc/default/influxdb') }
    it { is_expected.to contain_file('/etc/default/influxdb').with_content(/INFLUXD_OPTS="OPTIONS"/) }
    it { is_expected.to contain_file('/etc/default/influxdb').with_content(/STDERR=\/var\/log\/influxdb\/influxd\.log/) }
  end
end
