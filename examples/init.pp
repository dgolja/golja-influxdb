class { '::influxdb':
  manage_repos => true,
}

influxdb_retention_policy { 'myrp1@mydb1':
  duration => '1h',
  default  => false,
}

influxdb_retention_policy { 'myrp2@mydb1':
  duration => '20h',
  default  => true,
}

influxdb_database { 'mydb1': }

influxdb_database { 'mydb2': }

influxdb_retention_policy { 'myrp1@mydb2':
  duration    => '4h10m10s',
  replication => 2,
}
