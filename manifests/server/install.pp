# PRIVATE CLASS: do not use directly
class influxdb::server::install {
  $ensure = $influxdb::server::ensure
  $version = $influxdb::server::version
  $repo_stage = $influxdb::server::repo_stage
  Exec {
    path => '/usr/bin:/bin',
  }

  if $influxdb::server::manage_install {
    if $ensure == 'absent' {
      $_ensure = $ensure
      } else {
        $_ensure = $version
      }

    class { 'influxdb::repo':
      stage => $repo_stage,
    } ->

    package { 'influxdb':
      ensure => $version,
      tag    => 'influxdb',
    }
  }
}
