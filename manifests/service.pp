#
class influxdb::service(
  $service_enabled = $influxdb::service_ensure,
){

  $service_ensure = $service_enabled ? {
    true    => 'running',
    false   => 'stopped',
    default => 'running',
  }

  service { 'influxdb':
    ensure     => $service_ensure,
    enable     => $service_enabled,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['influxdb'],
  }

}
