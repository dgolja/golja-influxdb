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

require 'net/http'
require 'json'

class Puppet::Provider::InfluxDB < Puppet::Provider
  # @abstract Subclass is expected to implement #base_url
  # @method base_url
  #   The base URL to InfluxDB API
  #
  #   Normally we don't want to do this but it's
  #   easier to stub in testing.
  def self.base_url
    raise NotImplementedError
  end

  # @method parse_url
  #   Parse the base URL and fix the path that will be used for the requests.
  #   Protected function that can only used by this class and subclasses that
  #   inherits this class.
  # @param path
  #   The path to add to the base URL, must start with a slash
  #   or URI will throw an exception.
  # @param query
  #   Optional parameter if the query parameters that should be added to
  #   the URL.
  protected
  def self.parse_url(path, query=nil)
    url = URI.parse(base_url)
    path.prepend('/') unless path[0] == '/'
    url.path = URI.escape(path)
    url.query = URI.escape(query) if query
    url
  end

  # @method query
  #   Run a query against the InfluxDB API
  # @param query
  #   The query to run
  def self.query(query)
    q = "q=#{query}"
    post('query', q)
  end

  # @method get
  #   Perform a GET request
  # @param path
  #   The path to perform a GET request against
  # @param query
  #   The query to add to the URL
  # @param data
  #   The data to send with the request
  # @param headers
  #   The headers to send with the request
  def self.get(path, query=nil, data=nil, headers=nil)
    perform_request('GET', path, query, data, headers)
  end

  # @method post
  #   Perform a POST request.
  # @param path
  #   The path to perform a POST request against
  # @param query
  #   The query to add to the URL
  # @param data
  #   The data to send with the request
  # @param headers
  #   The headers to send with the request
  def self.post(path, query=nil, data=nil, headers=nil)
    perform_request('POST', path, query, data, headers)
  end

  # @method databases
  #   Get all InfluxDB databases and introduce a retry
  #   because when the service is being deployed for the
  #   first time and is initializing the SHOW DATABASES
  #   query will respond without the "values" key in the
  #   response.
  #
  #   If we instead wait for it to initialize and create
  #   the "_internal" database we'll get the list properly.
  #
  #   This effectively allows for InfluxDB to initialize.
  def self.databases
    q = 'SHOW DATABASES'
    retry_count = 1
    begin
      response = query(q)
      if response.code.to_i != 200
        raise Puppet::Error, "Failed to get InfluxDB databases (HTTP response: #{response.code})"
      end
      data = JSON.parse(response.body)
      results = data['results'][0]
      series = results['series']
      if !series[0].include?('values')
        raise Puppet::Error, 'InfluxDB database response did not contain values, service not started or initialized yet'
      end
      values = series[0]['values']
    rescue => e
      if retry_count <= 30
        Puppet.debug("InfluxDB database: #{e.message}, retrying in #{retry_count} seconds")
        retry_count += 1
        Kernel.sleep 2
        retry
      end
      raise
    end
    ret = values.collect do |value|
      value[0]
    end
    ret
  end

  # @method perform_request
  #   Perform a HTTP request.
  # @param type
  #   The HTTP request type
  # @param path
  #   The path to perform the request against.
  # @param data
  #   The data to send with the request
  # @param headers
  #   Hash with headers to add to the request
  private
  def self.perform_request(type, path, query=nil, data=nil, headers=nil)
    url = parse_url(path, query)
    case type.upcase
    when 'GET'
      request = Net::HTTP::Get.new(url.request_uri)
    when 'POST'
      request = Net::HTTP::Post.new(url.request_uri)
    else
      raise Puppet::Error, "Unsupported HTTP request type: #{type}"
    end
    request.content_type = 'application/json'
    request.body = data
    if headers then
      headers.each do |key, value|
        if !value.is_a?(String) then
          val = value.to_s
        else
          val = value
        end

        request[key] = val
      end
    end
    retry_count = 1
    begin
      response = Net::HTTP.start(url.host, url.port,
                                 :use_ssl => url.scheme == 'https') do |http|
        http.request(request)
      end
    rescue => e
      if retry_count <= 3
        Puppet.debug("InfluxDB API call failed attempt #{retry_count}: #{e.message}.. retrying in #{retry_count} seconds")
        retry_count += 1
        Kernel.sleep retry_count
        retry
      end
      raise Puppet::Error, "InfluxDB API call failed after #{retry_count} retries: #{e.message}"
    end
    response
  end
end
