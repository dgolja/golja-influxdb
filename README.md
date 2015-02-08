# InfluxDB

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Installation](#installation)
4. [Setup - The basics of getting started with influxdb](#setup)
5. [Usage - Configuration options and additional functionality](#usage)
6. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
7. [Limitations - OS compatibility, etc.](#limitations)
8. [Development - Guide for contributing to the module](#development)
9. [License](#License)

##Overview

This module manages InfluxDB installation.

[![Build Status](https://travis-ci.org/n1tr0g/golja-influxdb.png)](https://travis-ci.org/n1tr0g/golja-influxdb)

##Module Description

The InfluxDB module manages both the installation and configuration of InfluxDB. I am planning to extend it to
allow management of InfluxDB resources, such as databases, users, and privileges.

*NOTE*: Until 1.0.0 release the API may change, however I will try my best to avoid it.

##Installation

`puppet module install golja/influxdb`

##Setup

### What InfluxDB affects

* InfluxDB packages
* InfluxDB configuration files
* InfluxDB service

###Beginning with InfluxDB

If you just want a server installed with the default options you can run include `'::influxdb::server'`.

##Usage

All interaction for the server is done via `influxdb::server`.

###Overrides

Due to the nature of InfluxDB we use the concept of overrides to add custom input 
plugins or/and additional storage engines. Some of the standards storage engines
can be managed via params too. For some examples check below.

###Enable graphite plugin

```puppet
class {'influxdb::server':
  input_plugins => {
    'input_plugins.graphite' => {
       'enabled'             => true,
       'address'             => '0.0.0.0',
       'port'                => 2003,
       'database'            => 'graphitedb',
       'udp_enabled'         => true,
    }
  }
}
```

###Add custom storage engine

```puppet
class {'influxdb::server':
  override_storage_engines => {
    'storage.engines.dummy' => {
      'max-open-files' => 1000,
      'lru-cache-size' => '500m',
    },
  }
}
```

###Override the default value for rocksdb

```puppet
class {'influxdb::server':
  override_storage_engines => {
    'storage.engines.rocksdb'  => {
      'max-open-files' => 2000,
      'lru-cache-size' => '1g',
    },
  }
}
```

##Reference

###Classes

####Public classes
* `influxdb::server`: Installs and configures InfluxDB.

####Private classes
* `influxdb::server::install`: Installs packages.
* `influxdb::server::config`: Configures InfluxDB.
* `influxdb::server::service`: Manages service.

###Parameters

####influxdb::server

#####`ensure`

Allows you to install or remove InfluxDB. Can be 'present' or 'absent'.

#####`version`

Version of InfluxDB. Default: latest

#####`config_file`

Path to the config file. Default: OS specific

#####`service_provider`

The provider to use to manage the service. Default: OS specific

#####`service_enabled`

Boolean to decide if the service should be enabled.

#####`package_provider`

What provider should be used to install the package.

#####`hostname`

Server hostname used for clustering. Default: undef

#####`bind_address`

This setting can be used to configure InfluxDB to bind to and listen for connections 
from applications on this address. If not specified, the module will use the default for your OS distro.

#####`reporting_disabled`

If enabled once every 24 hours InfluxDB will report anonymous data to m.influxdb.com. Default: false

#####`log_level`

logging level can be one of "fine", "debug", "info", "warn" or "error". Default: info

#####`admin_port`

Configure the admin server port. Binding is disabled if the port isn't set. Default: 8083

#####`api_port`

Configure the http api. Binding is disabled if the port isn't set. Default: 8086

#####`enable_ssl`

Enable ssl for the API. Default: false

#####`ssl_port`

Ssl port for the API. Default: 8087

#####`ssl_path`

Path of the SSL cert. Default: undef

#####`read_timeout`

Connections will timeout after this amount of time. Default: 5s

#####`input_plugins`

Hash of input plugins. For more info how to use it check [Usage](#usage)

#####`conf_template`

Location of the config template. Default: influxdb/config.toml.erb

#####`influxdb_user`

User under which we run the InfluxDB server. Default: OS specific

#####`influxdb_group`

Group under which we run the InfluxDB server. Default: OS specific

#####`raft_port`

Raft port used for cluster: Default: 8090

#####`raft_log_dir`

Where the raft logs are stored. The user running InfluxDB will need read/write access. Default: /opt/influxdb/shared/data/raft (OS Specific)
#####`raft_debug`

Turn raft debuging on. Default: false

#####`storage_dir`

Storage dir. Default: /opt/influxdb/shared/data/db (OS Specific)

#####`storage_write_buffer_size`

How many requests to potentially buffer in memory. Default: 10000

#####`default_engine`

the engine to use for new shards, old shards will continue to use the same engine. Default: leveldb

#####`max_open_shards`

The default setting on this is 0, which means unlimited.

#####`point_batch_size`

This option tells how many points will be fetched from LevelDb before they get flushed into backend. Default: 100

#####`write_batch_size`

The number of points to batch in memory before writing them to leveldb. Default: 5000000

#####`retention_sweep_period`

The server will check this often for shards that have expired that should be cleared. Default: 10m

#####`override_storage_engines`

Hash of storage engines. For more info how to use it check [Usage](#usage). Default: {}

#####`seed_servers`

A comma separated list of servers to seed this server. Example: seed-servers = ["hosta:8090","hostb:8090"]. Default: undef

#####`protobuf_port`

Replication happens over a TCP connection with a Protobuf protocol. This define the port. Default: 8099

#####`protobuf_timeout`

The write timeout on the protobuf conn any duration parseable by time.ParseDuration. Default: 2s

#####`protobuf_heartbeat`

The heartbeat interval between the servers. must be parseable by time.ParseDuration. Default: 200ms

#####`protobuf_min_backoff`

The minimum backoff after a failed heartbeat attempt. Default: 1s

#####`protobuf_max_backoff`

The maxmimum backoff after a failed heartbeat attempt. Default: 10s

#####`cluster_write_buffer_size`

How many write requests to potentially buffer in memory per server. Default: 1000

#####`cluster_max_response_buffer_size`

The maximum number of responses to buffer from remote nodes. Default: 100

#####`concurrent_shard_query_limit`

Limit of concurrent query per shard. Setting this higher will give better performance, but you'll need more memory. Default: 10

#####`wal_dir`

Dir where to store wal data. Default: OS Specific

#####`wal_flush_after`

The number of writes after which wal will be flushed, 0 for flushing on every write. Default: 1000

#####`wal_bookmark_after`

The number of writes after which a bookmark will be created. Default: 1000

#####`wal_index_after`

The number of writes after which an index entry is created pointing. Default: 1000

#####`wal_requests_per_logfile `

The number of requests per one log file, if new requests came in a new log file will be created. Default: 10000

##Limitations

This module has been tested on:

* Ubuntu 12.04
* Ubuntu 14.04
* CentOS 6/7
 
##Development

Please see CONTRIBUTING.md

###Todo

* Add native types for managing users and databases
* Add more rspec tests
* Add beaker/rspec tests

##License

See LICENSE file
