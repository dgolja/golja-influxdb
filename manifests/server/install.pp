class influxdb::server::install {
  $version = $influxdb::server::version
  
  package {'influxdb':
    ensure   => $influxdb::server::package_ensure,
    provider => $influxdb::server::package_provider,
    source   => "/tmp/influxdb_${version}${influxdb::params::package_suffix}",
  }

  # hopefully soon they will have an proper repo
  exec {'get_influxdb':
    command => "/usr/bin/curl ${influxdb::params::package_source}${version}${influxdb::params::package_suffix} -o /tmp/influxdb_${version}${influxdb::params::package_suffix} && touch /tmp/.get_influxdb_${version}",
    creates => "/tmp/.get_influxdb_${version}",
    before  => Package['influxdb'],
  }

}