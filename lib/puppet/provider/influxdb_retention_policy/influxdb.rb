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

Puppet::Type.type(:influxdb_retention_policy).provide(:influxdb, :parent => Puppet::Provider::InfluxDB) do
  desc "Provider for influxdb_retention_policy type"

  defaultfor :kernel => 'Linux'

  mk_resource_methods

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  # @method base_url
  #   The base URL used by Puppet::Provider::InfluxDB
  def self.base_url
    'http://localhost:8086'
  end

  # @method create
  #   Create the InfluxDB retention policy on the database
  def create
    name_split = resource[:name].split('@')
    rp_name = name_split.first
    db_name = name_split.last
    default_str = ''
    default_str = ' DEFAULT' if resource[:default] == :true
    q = "CREATE RETENTION POLICY #{rp_name} ON #{db_name} DURATION #{resource[:duration]}s REPLICATION #{resource[:replication]}#{default_str}"
    response = self.class.query(q)
    if response.code.to_i != 200
      raise Puppet::Error, "Failed to create InfluxDB retention policy: #{rp_name} on database #{db_name} (HTTP response: #{response.code})"
    end
    data = JSON.parse(response.body)
    if data.include?('results')
      result = data['results'][0]
      if result.include?('error') and result['error'].include?('database not found')
        fail Puppet::Error, "Failed to create InfluxDB retention policy #{rp_name}: database #{db_name} does not exist"
      end
    end
  end

  # @method destroy
  #   Destroy the InfluxDB retention policy on the database
  def destroy
    name_split = resource[:name].split('@')
    rp_name = name_split.first
    db_name = name_split.last
    if resource[:default] == :true
      Puppet.warning("Deleting default InfluxDB retention policy #{rp_name} on databse #{db_name}, this database will have no default retention policy")
    end
    q = "DROP RETENTION POLICY #{rp_name} ON #{db_name}"
    response = self.class.query(q)
    if response.code.to_i != 200
      raise Puppet::Error, "Failed to delete InfluxDB retention policy: #{rp_name} on database #{db_name} (HTTP response: #{response.code})"
    end
  end

  # @method exists?
  #   Check if the retention policy exist
  def exists?
    unless @instances
      @instances = self.class.instances
    end
    @instances.any? {|prov| prov.name == resource[:name]}
  end

  # @method retention_policies
  #   Get all InfluxDB retention policies on the database
  def self.retention_policies(database)
    q = "SHOW RETENTION POLICIES ON #{database}"
    response = self.query(q)
    if response.code.to_i != 200
      raise Puppet::Error, "Failed to get InfluxDB retention policies for database #{database} (HTTP response: #{response.code})"
    end
    data = JSON.parse(response.body)
    results = data['results'][0]
    series = results['series']
    values = series[0]['values']
    values
  end

  # @method duration
  #   Parse a duration to seconds
  def self.duration_to_seconds(duration)
    if duration.is_a?(Integer)
      return duration
    end
    measure_to_seconds = {
      's' => 1,
      'm' => 60,
      'h' => (60 * 60),
      'd' => (60 * 60 * 24),
      'w' => (60 * 60 * 24 * 7)
    }
    seconds = 0
    duration.scan(/(\d+)(\w)/).each do |value, measure|
      seconds += value.to_i * measure_to_seconds[measure]
    end
    seconds
  end

  # @method instances
  #   Get all InfluxDB retention policies and create resources
  def self.instances
    dbs = self.databases
    ret = []
    dbs.each do |db|
      rps = self.retention_policies(db) 
      ret << rps.collect do |rp|
        default_sym = :false
        if rp[4].to_s == 'true'
          default_sym = :true
        end
        new(
          :name        => "#{rp[0]}@#{db}",
          :duration    => self.duration_to_seconds(rp[1]),
          :replication => rp[3],
          :default     => default_sym,
        )
      end
    end
    ret.flatten
  end

  # @method prefetch
  #   Associate all the InfluxDB retention policy resource with a resource
  def self.prefetch(resources)
    rps = instances
    resources.keys.each do |name|
      if provider = rps.find{ |rp| rp.name == name }
        resources[name].provider = provider
      end
    end
  end

  # @method flush
  #   Flush changed params to InfluxDB
  def flush
    unless @property_flush.empty?
      name_split = resource[:name].split('@')
      rp_name = name_split.first
      db_name = name_split.last
      q = "ALTER RETENTION POLICY #{rp_name} ON #{db_name}"

      if @property_flush[:duration]
        q << ' DURATION ' << @property_flush[:duration].to_s << 's'
      else
        q << ' DURATION ' << resource[:duration].to_s << 's'
      end
      if @property_flush[:replication]
        q << ' REPLICATION ' << @property_flush[:replication].to_s
      else
        q << ' REPLICATION ' << resource[:replication].to_s
      end
      if @property_flush[:default] == :true or (resource[:default] == :true and !@property_flush.include? :default)
        q << ' DEFAULT'
      end
      response = self.class.query(q)
      if response.code.to_i != 200
        raise Puppet::Error, "Failed to flush InfluxDB retention policy: #{rp_name} on database #{db_name} (HTTP response: #{response.code})"
      end
    end
  end

  def duration=(value)
    new_value = self.class.duration_to_seconds(value)
    old_value = self.class.duration_to_seconds(@property_hash[:duration])
    if new_value and old_value and new_value.to_i != old_value.to_i
      @property_flush[:duration] = value
    end
  end

  def replication=(value)
    @property_flush[:replication] = value
  end

  def default=(value)
    @property_flush[:default] = value
  end
end
