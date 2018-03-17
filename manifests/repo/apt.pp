# PRIVATE CLASS: do not use directly

class influxdb::repo::apt(
  $ensure = 'present',
) {

  #downcase operatingsystem
  $_operatingsystem = downcase($::operatingsystem)

  apt::source { 'influxdb':
    ensure   => $ensure,
    location => 'https://repos.influxdata.com/${_operatingsystem}',
    repos    => 'stable',
    key      => {
      'id'      => '05CE15085FC09D18E99EFB22684A14CF2582E0C5',
      'server'  => 'repos.influxdata.com',
      'source'  => 'https://repos.influxdata.com/influxdb.key',
    },
  }
}
