# PRIVATE CLASS: do not use directly
class influxdb::repo::yum {

  $_operatingsystem = $::operatingsystem ? {
    'CentOS' => downcase($::operatingsystem),
    default  => 'rhel',
  }

  if !defined(Yumrepo['influxdata'])
  {
    yumrepo {'influxdata':
      descr    => "InfluxData Repository - ${::operatingsystem} \$releasever",
      baseurl  => "https://repos.influxdata.com/${_operatingsystem}/\$releasever/\$basearch/stable",
      enabled  => 1,
      gpgcheck => 1,
      gpgkey   => 'https://repos.influxdata.com/influxdb.key',
    }

    Yumrepo['influxdata'] -> Package<| tag == 'influxdb' |>
  }
}
