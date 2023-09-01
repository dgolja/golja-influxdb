#
class influxdb::repo {

  case $facts['os']['family'] {
    'Debian': {
      require influxdb::repo::apt
    }

    'RedHat': {
      require influxdb::repo::yum
    }

    default: {
      fail("Unsupported managed repository for osfamily: ${facts['os']['family']}, operatingsystem: ${facts['os']['name']},\
      module ${module_name} currently only supports managing repos for osfamily RedHat and Debian")
    }

  }

}
