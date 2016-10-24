# PRIVATE CLASS: do not use directly

class influxdb::repo::apt {

  #downcase operatingsystem
  $_operatingsystem = downcase($::operatingsystem)

  apt::source { 'repos.influxdata.com':
    location    => "https://repos.influxdata.com/${_operatingsystem}",
    release     => $::lsbdistcodename,
    repos       => 'stable',
    key         => '05CE15085FC09D18E99EFB22684A14CF2582E0C5',
    key_source  => 'https://repos.influxdata.com/influxdb.key',
    include_src => false,
  }

  exec { "apt-update":
      command => "/usr/bin/apt-get update"
  }

  Apt::Source['repos.influxdata.com'] -> Exec["apt-update"] -> Package<| tag == 'influxdb' |>
}
