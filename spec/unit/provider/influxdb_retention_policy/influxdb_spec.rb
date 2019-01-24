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
require 'json'
require 'puppet/provider/influxdb_retention_policy/influxdb'

describe Puppet::Type.type(:influxdb_retention_policy).provider(:influxdb) do
  let(:resource_attrs) do
    {
      :ensure      => :present,
      :name        => 'rp@db',
      :duration    => '1h',
      :replication => 2,
      :default     => true,
    }
  end

  let(:resource) do
    Puppet::Type::Influxdb_retention_policy.new(resource_attrs)
  end

  let(:provider) do
    described_class.new(resource)
  end

  describe '#base_url' do
    it 'should return base url' do
      expect(provider.class.base_url).to eq('http://localhost:8086')
    end
  end

  class HttpPolicyResponseMock
    def code
      '200'
    end

    def body
      '{"results":[{"statement_id":0,"series":[{"columns":["name","duration","shardGroupDuration","replicaN","default"],"values":[["autogen","0s","168h0m0s",1,false],["rp","1h0m0s","2h0m0s",2,true]]}]}]}'
    end
  end

  class HttpResponseMockWithDatabaseNotFound
    def code
      '200'
    end

    def body
      '{"results":[{"statement_id":0,"error":"database not found: testdb2"}]}'
    end
  end

  describe '#create' do
    it 'should be successful' do
      described_class.expects(:query).with('CREATE RETENTION POLICY rp ON db DURATION 3600s REPLICATION 2 DEFAULT').returns(HttpPolicyResponseMock.new)
      provider.create
    end

    it 'should fail when database not found' do
      described_class.expects(:query).with('CREATE RETENTION POLICY rp ON db DURATION 3600s REPLICATION 2 DEFAULT').returns(HttpResponseMockWithDatabaseNotFound.new)
      expect { provider.create }.to raise_error(Puppet::Error)
    end
  end

  describe '#destroy' do
    it 'should be successful' do
      response = Net::HTTPResponse.new('1.0', '200', '')
      described_class.expects(:query).with('DROP RETENTION POLICY rp ON db').returns(response)
      provider.destroy
    end

    it 'should fail' do
      response = Net::HTTPResponse.new('1.0', '500', '')
      described_class.expects(:query).with('DROP RETENTION POLICY rp ON db').returns(response)
      expect { provider.destroy }.to raise_error(Puppet::Error)
    end
  end

  describe '#exists' do
    it 'should exist' do
      described_class.expects(:instances).returns([resource])
      expect(provider.exists?).to be_truthy
    end

    context 'should not exist' do
      it 'when no resources' do
        described_class.expects(:instances).returns([])
        expect(provider.exists?).to be_falsey
      end

      it 'when no matching resources' do
        resource1 = Puppet::Type::Influxdb_retention_policy.new({:name => 'rp1@db1'})
        resource2 = Puppet::Type::Influxdb_retention_policy.new({:name => 'rp2@db2'})
        described_class.expects(:instances).returns([resource1, resource2])
        expect(provider.exists?).to be_falsey
      end
    end
  end

  describe '#retention_policies' do
    it 'should get rps' do
      described_class.expects(:query).with('SHOW RETENTION POLICIES ON db').returns(HttpPolicyResponseMock.new)
      expected = [["autogen","0s","168h0m0s",1,false],["rp","1h0m0s","2h0m0s",2,true]]
      expect(described_class.retention_policies('db')).to eq(expected)
    end

    it 'should fail' do
      response = Net::HTTPResponse.new('1.0', '500', '')
      described_class.expects(:query).with('SHOW RETENTION POLICIES ON db').returns(response)
      expect { described_class.retention_policies('db') }.to raise_error(Puppet::Error)
    end
  end

  describe '#duration_to_seconds' do
    it 'should return if integer' do
      expect(described_class.duration_to_seconds(1)).to eq(1)
    end

    it 'should compute seconds to seconds' do
      expect(described_class.duration_to_seconds('2s')).to eq(2)
    end

    it 'should do a simple compute to seconds' do
      expect(described_class.duration_to_seconds('1h')).to eq(3600)
    end

    it 'should do a full compute to seconds' do
      expect(described_class.duration_to_seconds('1w1d1h1m10s')).to eq(694870)
    end
  end

  describe '#instances' do
    it 'should get instances' do
      described_class.expects(:databases).returns(['db1', 'db2'])
      described_class.expects(:retention_policies).with('db1').returns([["autogen","0s","168h0m0s",1,false],["db1rp","2h0m0s","4h0m0s",2,true]])
      described_class.expects(:retention_policies).with('db2').returns([["autogen","0s","168h0m0s",1,false],["db2rp","1h0m0s","2h0m0s",1,false]])
      instances = Puppet::Type::Influxdb_retention_policy::ProviderInfluxdb.instances
      expect(instances.count).to eq(4)

      expect(instances[0].name).to eq('autogen@db1')
      expect(instances[0].duration).to eq(0)
      expect(instances[0].replication).to eq(1)
      expect(instances[0].default).to eq(:false)
      expect(instances[1].name).to eq('db1rp@db1')
      expect(instances[1].duration).to eq(7200)
      expect(instances[1].replication).to eq(2)
      expect(instances[1].default).to eq(:true)

      expect(instances[2].name).to eq('autogen@db2')
      expect(instances[2].duration).to eq(0)
      expect(instances[2].replication).to eq(1)
      expect(instances[2].default).to eq(:false)
      expect(instances[3].name).to eq('db2rp@db2')
      expect(instances[3].duration).to eq(3600)
      expect(instances[3].replication).to eq(1)
      expect(instances[3].default).to eq(:false)
    end

    it 'should get no instances' do
      described_class.expects(:databases).returns([])
      instances = Puppet::Type::Influxdb_retention_policy::ProviderInfluxdb.instances
      expect(instances.count).to eq(0)
    end
  end

  describe '#prefetch' do
    it 'should associate provider' do
      resource1 = Puppet::Type::Influxdb_retention_policy.new(
        :name     => 'rp1@db1',
        :duration => '1h'
      )
      resource2 = Puppet::Type::Influxdb_retention_policy.new(
        :name     => 'rp1@db1',
        :duration => '1h'
      )
      described_class.expects(:instances).returns([resource1, resource2])
      resources = {'rp@db' => {'ensure' => 'present', 'duration' => '1h'}}
      Puppet::Type::Influxdb_retention_policy::ProviderInfluxdb.prefetch(resources)
      expect(resource.provider).to eq(provider)
    end
  end

  describe '#flush' do
    it 'should not flush anything' do
      described_class.expects(:query).never
      provider.flush
    end

    it 'should successfully flush all' do
      response = Net::HTTPResponse.new('1.0', '200', '')
      described_class.expects(:query).with('ALTER RETENTION POLICY rp ON db DURATION 36000s REPLICATION 10').returns(response)
      provider.instance_variable_get('@property_hash')[:duration] = 3600
      provider.duration = 36000
      provider.replication = '10'
      provider.default = :false
      provider.flush
    end

    it 'should flush duration' do
      response = Net::HTTPResponse.new('1.0', '200', '')
      described_class.expects(:query).with('ALTER RETENTION POLICY rp ON db DURATION 7200s REPLICATION 2 DEFAULT').returns(response)
      provider.instance_variable_get('@property_hash')[:duration] = 3600
      provider.duration = 7200
      provider.flush
    end

    it 'should not flush if duration not changed' do
      described_class.expects(:query).never
      provider.instance_variable_get('@property_hash')[:duration] = 3600
      provider.duration = 3600
      provider.flush
    end

    it 'should flush replication' do
      response = Net::HTTPResponse.new('1.0', '200', '')
      described_class.expects(:query).with('ALTER RETENTION POLICY rp ON db DURATION 3600s REPLICATION 30 DEFAULT').returns(response)
      provider.replication = 30
      provider.flush
    end

    it 'should flush default' do
      response = Net::HTTPResponse.new('1.0', '200', '')
      described_class.expects(:query).with('ALTER RETENTION POLICY rp ON db DURATION 3600s REPLICATION 2').returns(response)
      provider.default = :false
      provider.flush
    end
  end
end
