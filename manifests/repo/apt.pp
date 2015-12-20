# PRIVATE CLASS: do not use directly

class influxdb::repo::apt {

  #downcase operatingsystem
  $_operatingsystem = downcase($::operatingsystem)

  apt::source { 'repos.influxdata.com':
    location => "https://repos.influxdata.com/${_operatingsystem}",
    release  => $::lsbdistcodename,
    repos    => 'stable',
    include  => {
      'src' => false
    },
    key      => {
      'id'     => '05CE15085FC09D18E99EFB22684A14CF2582E0C5',
      'source' => 'https://repos.influxdata.com/influxdb.key'
    },
  }

  Apt::Source['repos.influxdata.com'] -> Package<| tag == 'influxdb' |>
}