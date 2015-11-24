class influxdb::server::install {
  $version = $influxdb::server::version

  Exec {
    path => '/usr/bin:/bin',
  }

  if $influxdb::server::manage_install {
    # Until they release a proper repository we will need to do with that
    exec {'get_influxdb':
      command => "curl -s ${influxdb::params::package_source}${version}${influxdb::params::package_suffix} -o /tmp/influxdb_${version}${influxdb::params::package_suffix} && touch /tmp/.get_influxdb_${version}",
      creates => "/tmp/.get_influxdb_${version}",
    } ->

    package {'influxdb':
      ensure   => $influxdb::server::ensure,
      provider => $influxdb::server::package_provider,
      source   => "/tmp/influxdb_${version}${influxdb::params::package_suffix}",
    }
  }
}