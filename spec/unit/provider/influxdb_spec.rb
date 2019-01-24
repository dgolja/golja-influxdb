# Copyright (C) 2018 Binero
#
# Author: Tobias Urdin <tobias.urdin@binero.se>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

require 'spec_helper'
require 'puppet/provider/influxdb'

describe Puppet::Provider::InfluxDB do
  describe '#parse_url' do
    it 'should parse url' do
      Puppet::Provider::InfluxDB.expects(:base_url).returns('http://localhost:8086').at_most(4)
      url1 = described_class.parse_url('first_url')
      url2 = described_class.parse_url('/second_url')
      url3 = described_class.parse_url('third_url', 'q=test query')
      url4 = described_class.parse_url('fourth_url', 'q=test1&w=test2 test3')
      exp1 = URI::parse('http://localhost:8086/first_url')
      expect(url1).to eq(exp1)
      exp2 = URI::parse('http://localhost:8086/second_url')
      expect(url2).to eq(exp2)
      exp3 = URI::parse('http://localhost:8086/third_url?q=test%20query')
      expect(url3).to eq(exp3)
      exp4 = URI::parse('http://localhost:8086/fourth_url?q=test1&w=test2%20test3')
      expect(url4).to eq(exp4)
    end
  end

  describe '#query' do
    it 'should do a query' do
      described_class.expects(:post).with('query', 'q=query here').returns(true)
      expect(described_class.query('query here')).to be_truthy
    end
  end

  describe '#get' do
    it 'should do a get' do
      described_class.expects(:perform_request).with('GET', 'query', 'q=test', nil, nil).returns(true)
      expect(described_class.get('query', 'q=test')).to be_truthy
    end
  end

  describe '#post' do
    it 'should do a post' do
      described_class.expects(:perform_request).with('POST', 'query', 'q=test', nil, nil).returns(true)
      expect(described_class.post('query', 'q=test')).to be_truthy
    end
  end

  class HttpResponseMock
    def code
      '200'
    end

    def body
      '{"results":[{"statement_id":0,"series":[{"name":"databases","columns":["name"],"values":[["_internal"],["db1"],["db2"]]}]}]}'
    end
  end

  class HttpResponseMockWithoutValues
    def code
      '200'
    end

    def body
      '{"results":[{"statement_id":0,"series":[{"name":"databases","columns":["name"]}]}]}'
    end
  end

  describe '#databases' do
    it 'should return the instances when response contains values' do
      described_class.expects(:query).with('SHOW DATABASES').returns(HttpResponseMock.new)
      instances = Puppet::Type::Influxdb_database::ProviderInfluxdb.instances
      expect(instances.count).to eq(3)
      expect(instances[0].name).to eq('_internal')
      expect(instances[1].name).to eq('db1')
      expect(instances[2].name).to eq('db2')
    end

    it 'should retry and fail' do
      Kernel.expects(:sleep).returns(true).times(30)
      described_class.expects(:query).with('SHOW DATABASES').returns(HttpResponseMockWithoutValues.new).times(31)
      expect { Puppet::Type::Influxdb_database::ProviderInfluxdb.instances }.to raise_error(Puppet::Error)
    end

    it 'should retry and success' do
      Kernel.expects(:sleep).returns(true).times(12)
      described_class.expects(:query).with('SHOW DATABASES').returns(HttpResponseMock.new)
      described_class.expects(:query).with('SHOW DATABASES').returns(HttpResponseMockWithoutValues.new).times(12)
      instances = Puppet::Type::Influxdb_database::ProviderInfluxdb.instances
      expect(instances.count).to eq(3)
      expect(instances[0].name).to eq('_internal')
      expect(instances[1].name).to eq('db1')
      expect(instances[2].name).to eq('db2')
    end
  end

  describe '#perform_request' do
    before :each do
      Puppet::Provider::InfluxDB.expects(:base_url).returns('http://localhost:8086')
    end

    it 'should do a default get' do
      Net::HTTP.expects(:start).returns(true)
      response = described_class.perform_request('GET', 'path')
      expect(response).to eq(true)
    end

    it 'should do a get with query, data and headers' do
      Net::HTTP.expects(:start).returns(true)
      response = described_class.perform_request('GET', 'path', 'q=query', 'data', {'my' => 'header'})
      expect(response).to eq(true)
    end

    it 'should fail' do
      expect { described_class.perform_request('what', 'path') }.to raise_error(Puppet::Error)
    end

    it 'should retry and fail' do
      Kernel.expects(:sleep).returns(true).times(3)
      Net::HTTP.expects(:start).with('localhost', 8086, { :use_ssl => false }).raises(StandardError).times(4)
      expect { described_class.perform_request('GET', 'path') }.to raise_error(Puppet::Error)
    end

    it 'should retry and success' do
      Kernel.expects(:sleep).returns(true).times(3)
      Net::HTTP.expects(:start).returns(true)
      Net::HTTP.expects(:start).with('localhost', 8086, { :use_ssl => false }).raises(StandardError).times(3)
      response = described_class.perform_request('GET', 'path')
      expect(response).to eq(true)
    end
  end  
end
