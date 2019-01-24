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
require 'puppet/provider/influxdb_database/influxdb'

describe Puppet::Type.type(:influxdb_database).provider(:influxdb) do
  let(:resource_attrs) do
    {
      :name   => 'testdb',
      :ensure => :present,
    }
  end

  let(:resource) do
    Puppet::Type::Influxdb_database.new(resource_attrs)
  end

  let(:provider) do
    described_class.new(resource)
  end

  describe '#base_url' do
    it 'should return base url' do
      expect(provider.class.base_url).to eq('http://localhost:8086')
    end
  end

  describe '#create' do
    it 'should be successful' do
      response = Net::HTTPResponse.new('1.0', '200', 'test')
      described_class.expects(:query).with('CREATE DATABASE testdb').returns(response)
      provider.create
    end

    it 'should fail' do
      response = Net::HTTPResponse.new('1.0', '500', 'test')
      described_class.expects(:query).with('CREATE DATABASE testdb').returns(response)
      expect { provider.create }.to raise_error(Puppet::Error)
    end
  end

  describe '#destroy' do
    it 'should be successful' do
      response = Net::HTTPResponse.new('1.0', '200', 'test')
      described_class.expects(:query).with('DROP DATABASE testdb').returns(response)
      provider.destroy
    end

    it 'should fail' do
      response = Net::HTTPResponse.new('1.0', '500', 'test')
      described_class.expects(:query).with('DROP DATABASE testdb').returns(response)
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
        resource1 = Puppet::Type::Influxdb_database.new({:name => 'db1'})
        resource2 = Puppet::Type::Influxdb_database.new({:name => 'db2'})
        described_class.expects(:instances).returns([resource1, resource2])
        expect(provider.exists?).to be_falsey
      end
    end
  end

  describe '#instances' do
    it 'should get instances' do
      described_class.expects(:databases).returns(['db1', 'db2'])
      instances = Puppet::Type::Influxdb_database::ProviderInfluxdb.instances
      expect(instances.count).to eq(2)
      expect(instances[0].name).to eq('db1')
      expect(instances[1].name).to eq('db2')
    end

    it 'should get no instances' do
      described_class.expects(:databases).returns([])
      instances = Puppet::Type::Influxdb_database::ProviderInfluxdb.instances
      expect(instances.count).to eq(0)
    end
  end

  describe '#prefetch' do
    it 'should associate provider' do
      described_class.expects(:databases).returns(['db1', 'db2'])
      resources = {'testdb' => {'ensure' => 'present'}}
      Puppet::Type::Influxdb_database::ProviderInfluxdb.prefetch(resources)
      expect(resource.provider).to eq(provider)
    end
  end
end
