#

Facter.add(:influxdb_version) do
  setcode do
    if Facter::Util::Resolution.which('influx')

      
      package_name = Facter.value(:'influxdb::package_name')

      case package_name
      when 'influxdb'
        # InfluxDB shell version: >= 1.1.1 
        version_stdout = Facter::Util::Resolution.exec('influx --version')
      else 
        # InfluxDB shell version: >= 2.0.0
        version_stdout = Facter::Util::Resolution.exec('influx version')        
      end

      match = version_stdout.match(%r{[0-9]+\.[0-9]+\.[0-9]+})

      match ? match[0] : nil
    end
  end
end
