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

Puppet::Type.newtype(:influxdb_retention_policy) do
  @doc = "Manage retention policy in InfluxDB"

  ensurable do
    defaultvalues
    defaultto :present
  end

  def munge_boolean(value)
    case value
    when true, "true", :true
      :true
    when false, "false", :false
      :false
    else
      Puppet.fail('influxdb_retention_policy: must be boolean')
    end
  end

  def munge_integer(value)
    Integer(value)
  rescue ArgumentError
    Puppet.fail('influxdb_retention_policy: must be integer')
  end

  # TODO: Move this out to puppetx or util and
  # use it in provider as well.
  def duration_to_seconds(duration)
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

  def munge_duration(resource, value)
    new_value = resource.duration_to_seconds(value)
    if new_value < 3600
      Puppet.fail('influxdb_retention_policy: duration must be atleast 1 hour')
    end
    new_value  
  end

  newparam(:name, :namevar => true) do
    desc "The name of the retention policy."
    newvalues(/^\S+\@\S+$/)
  end

  newproperty(:duration) do
    desc "The duration to set on the retention policy."
    newvalues(/^(\d+w)?(\d+d)?(\d+h)?(\d+m)?(\d+s)?$/)

    munge do |value|
      @resource.munge_duration(@resource, value)
    end
  end

  newproperty(:replication) do
    desc "The number of replicas if cluster."
    defaultto(1)

    munge do |value|
      @resource.munge_integer(value)
    end
  end

  newproperty(:default, :boolean => true) do
    desc "Should the retention policy be default on this database."
    newvalues(:true, :false)
    defaultto(:false)

    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  autorequire(:influxdb_database) do
    self[:name].split('@').last
  end
end
