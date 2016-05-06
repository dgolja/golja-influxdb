# PRIVATE CLASS: do not use directly
class influxdb::server::install {
  $ensure = $influxdb::server::ensure
  $version = $influxdb::server::version

  Exec {
    path => '/usr/bin:/bin',
  }

  case $influxdb::server::install_method {
    'repo': {
      if $ensure == 'absent' {
        $_ensure = $ensure
      } else {
          $_ensure = $version
      }

      class { 'influxdb::repo': } ->

      package { 'influxdb':
        ensure => $_ensure,
        tag    => 'influxdb',
      }
    }
    'package': {
      class { 'influxdb::repo::package':
        package_source => $influxdb::server::package_source,
        version        => $influxdb::server::version
      }
    }
    default: {
      fail { 'unsupported install_method!': }
    }
  }
}
