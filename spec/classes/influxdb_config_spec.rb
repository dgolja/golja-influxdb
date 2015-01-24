require 'spec_helper'

describe 'influxdb::server', :type => :class do

  context 'with default values' do
    it { should contain_class('influxdb::server::install') }
    it { should contain_class('influxdb::server::config') }
    it { should contain_class('influxdb::server::service') }
  end

end