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
require 'puppet/type/influxdb_retention_policy'

describe Puppet::Type.type(:influxdb_retention_policy) do
  before do
    @influxdb_rp_resource = Puppet::Type::type(:influxdb_retention_policy).new(
      :name        => 'rp@mydb',
      :duration    => '1h',
      :replication => 1,
      :default     => true,
    )
  end

  it 'should have its name set' do
    expect(@influxdb_rp_resource[:name]).to eq('rp@mydb')
  end

  it 'should have its name set with numbers' do
    test_name_rp = Puppet::Type::type(:influxdb_retention_policy).new(
      :name        => 'rp1@mydb1',
      :duration    => '1h',
      :replication => 1,
    )
    expect(test_name_rp[:name]).to eq('rp1@mydb1')
  end

  it 'should fail with invalid name' do
    expect { Puppet::Type::type(:influxdb_retention_policy).new(
      :name        => 'invalid',
      :duration    => '1h',
      :replication => 1,
    ) }.to raise_error(Puppet::ResourceError)
  end

  it 'should have ensure present' do
    @influxdb_rp_resource[:ensure] = 'present'
    expect(@influxdb_rp_resource[:ensure]).to eq(:present)
  end

  it 'should have ensure absent' do
    @influxdb_rp_resource[:ensure] = 'absent'
    expect(@influxdb_rp_resource[:ensure]).to eq(:absent)
  end

  it 'should have duration set' do
    expect(@influxdb_rp_resource[:duration]).to eq(3600)
  end

  it 'multiple duration measures' do
    @influxdb_rp_resource[:duration] = '1w1d1h1m10s'
    expect(@influxdb_rp_resource[:duration]).to eq(694870)
  end

  it 'fails with invalid duration format' do
    expect { @influxdb_rp_resource[:duration] = '1h hello 1m world' }.to raise_error(Puppet::ResourceError)
  end

  it 'fails if duration is below 1 hour' do
    expect { @influxdb_rp_resource[:duration] = '59m' }.to raise_error(Puppet::ResourceError)
  end

  it 'should have replication set by default' do
    expect(@influxdb_rp_resource[:replication]).to eq(1)
  end

  it 'should set replication' do
    @influxdb_rp_resource[:replication] = 3
    expect(@influxdb_rp_resource[:replication]).to eq(3)
  end

  it 'with invalid replication string' do
    expect { @influxdb_rp_resource[:replication] = 'invalid' }.to raise_error(Puppet::ResourceError)
  end

  it 'with invalid replication spaces' do
    expect { @influxdb_rp_resource[:replication] = '1 2' }.to raise_error(Puppet::ResourceError)
  end

  it 'should have default set to true by default' do
    expect(@influxdb_rp_resource[:default]).to eq(:true)
  end

  it 'should have default set to true' do
     @influxdb_rp_resource[:default] = true
     expect(@influxdb_rp_resource[:default]).to eq(:true)
  end

  it 'should have default set to false' do
    @influxdb_rp_resource[:default] = false
    expect(@influxdb_rp_resource[:default]).to eq(:false)
  end

  it 'should have default set to true when using string' do
    @influxdb_rp_resource[:default] = 'true'
    expect(@influxdb_rp_resource[:default]).to eq(:true)
  end

  it 'should have default set to false when using string' do
    @influxdb_rp_resource[:default] = 'false'
    expect(@influxdb_rp_resource[:default]).to eq(:false)
  end
end
