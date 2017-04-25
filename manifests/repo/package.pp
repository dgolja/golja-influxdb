class influxdb::repo::package (
  $package_source,
  $version
) {
  case $::osfamily {
    'Debian': {
      wget::fetch { 'influxdb':
        source      => $package_source,
        destination => "/tmp/influxdb_${version}.deb"
      }

      package { 'influxdb':
        ensure   => present,
        provider => 'dpkg',
        source   => "/tmp/influxdb_${version}.deb",
        require  => Wget::Fetch['influxdb']
      }
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
