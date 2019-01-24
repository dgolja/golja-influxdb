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

require 'puppet'
require 'json'

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'influxdb'))

Puppet::Type.type(:influxdb_database).provide(:influxdb, :parent => Puppet::Provider::InfluxDB) do
  desc "Provider for influxdb_database type"

  defaultfor :kernel => 'Linux'

  # @method base_url
  #   The base URL used by Puppet::Provider::InfluxDB
  def self.base_url
    'http://localhost:8086'
  end

  # @method create
  #   Create the InfluxDB database
  def create
    q = "CREATE DATABASE #{resource[:name]}"
    response = self.class.query(q)
    if response.code.to_i != 200
      raise Puppet::Error, "Failed to create InfluxDB database: #{resource[:name]} (HTTP response: #{response.code})"
    end
  end

  # @method destroy
  #   Destroy the InfluxDB database
  def destroy
    q = "DROP DATABASE #{resource[:name]}"
    response = self.class.query(q)
    if response.code.to_i != 200
      raise Puppet::Error, "Failed to delete InfluxDB database: #{resource[:name]} (HTTP response: #{response.code})"
    end
  end

  # @method exists?
  #   Check if the database exists
  def exists?
    unless @instances
      @instances = self.class.instances
    end
    @instances.any? {|prov| prov.name == resource[:name]}
  end

  # @method instances
  #   Get all InfluxDB databases and create resources
  def self.instances
    dbs = self.databases
    ret = dbs.collect do |db_name|
      new(:name => db_name)
    end
    ret
  end

  # @method prefetch
  #   Associate all the InfluxDB database resource with a resource
  def self.prefetch(resources)
    databases = instances
    resources.keys.each do |name|
      if provider = databases.find{ |database| database.name == name }
        resources[name].provider = provider
      end
    end
  end
end
