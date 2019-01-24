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
require 'puppet/type/influxdb_database'

describe Puppet::Type.type(:influxdb_database) do
  before do
    @influxdb_db_resource = Puppet::Type::type(:influxdb_database).new(
      :name   => 'testdb',
    )
  end

  it 'should have its name set' do
    expect(@influxdb_db_resource[:name]).to eq('testdb')
  end

  it 'should allow numbers in name' do
    @influxdb_db_resource[:name] = 'mydb1'
    expect(@influxdb_db_resource[:name]).to eq('mydb1')
  end

  it 'should not allow invalid names' do
    expect { @influxdb_db_resource[:name] = 'my invalid name' }.to raise_error(Puppet::ResourceError)
  end

  it 'should have ensure present' do
    @influxdb_db_resource[:ensure] = 'present'
    expect(@influxdb_db_resource[:ensure]).to eq(:present)
  end

  it 'should have ensure absent' do
    @influxdb_db_resource[:ensure] = 'absent'
    expect(@influxdb_db_resource[:ensure]).to eq(:absent)
  end
end
