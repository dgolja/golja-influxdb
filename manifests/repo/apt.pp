# PRIVATE CLASS: do not use directly

class influxdb::repo::apt(
  $ensure = 'present',
) {

  #downcase operatingsystem
  $_operatingsystem = downcase($::operatingsystem)

  if $influxdb::package_name == 'influxdb2' {
    $key = {
      'id'      => '8C2D403D3C3BDB81A4C27C883C3E4B7317FFE40A',
      ' source' => 'https://repos.influxdata.com/influxdb2.key',
    }
  } else {
    $key = {
      'id'      => '05CE15085FC09D18E99EFB22684A14CF2582E0C5',
      ' source' => 'https://repos.influxdata.com/influxdb.key',
    }
  }

  $include = {
    'src' => false,
  }

  apt::source { 'repos.influxdata.com':
    ensure   => $ensure,
    location => "https://repos.influxdata.com/${_operatingsystem}",
    release  => $::lsbdistcodename,
    repos    => 'stable',
    key      => $key,
    include  => $include,
  }

}
