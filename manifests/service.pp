#
class influxdb::service(
  $service_ensure  = $influxdb::service_ensure,
  $service_enabled = $influxdb::service_enabled,
  $service_name    = $influxdb::service_name,
  $manage_service  = $influxdb::manage_service,
){

  if $manage_service {

    service { $service_name:
      ensure     => $service_ensure,
      enable     => $service_enabled,
      hasrestart => true,
      hasstatus  => true,
      require    => Package['influxdb'],
    }

  }

}
