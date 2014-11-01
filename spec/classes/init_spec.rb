require 'spec_helper'
describe 'influxdb' do

  context 'with defaults for all parameters' do
    it { should contain_class('influxdb') }
  end
end
