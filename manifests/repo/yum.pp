# PRIVATE CLASS: do not use directly
class influxdb::repo::yum(
  $ensure   = 'present',
  $enabled  = 1,
  $gpgcheck = 1,
) {

  if $influxdb::package_name == 'influxdb2' {
    $gpgkey ='https://repos.influxdata.com/influxdb2.key'
  } else {
    $gpgkey ='https://repos.influxdata.com/influxdb.key'
  }

  $_operatingsystem = $::operatingsystem ? {
    'CentOS' => downcase($::operatingsystem),
    default  => 'rhel',
  }

  yumrepo { 'repos.influxdata.com':
    ensure   => $ensure,
    descr    => "InfluxDB Repository - ${::operatingsystem} \$releasever",
    baseurl  => "https://repos.influxdata.com/${$_operatingsystem}/\$releasever/\$basearch/stable",
    enabled  => $enabled,
    gpgcheck => $gpgcheck,
    gpgkey   => $gpgkey,
  }

}
