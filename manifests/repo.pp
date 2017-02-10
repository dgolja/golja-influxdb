#
class influxdb::repo {

  case $::osfamily {
    'Debian': {
      include influxdb::repo::apt
    }

    'RedHat': {
      include influxdb::repo::yum
    }

    default: {
      fail("Unsupported managed repository for osfamily: ${::osfamily}, operatingsystem: ${::operatingsystem},\
      module ${module_name} currently only supports managing repos for osfamily RedHat and Debian")
    }

  }

}
