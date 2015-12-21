# InfluxDB

#### Table of Contents

1.  [Overview](#overview)
2.  [Module Description - What the module does and why it is useful](#module-description)
3.  [Installation](#installation)
4.  [Setup - The basics of getting started with influxdb](#setup)
5.  [Usage - Configuration options and additional functionality](#usage)
6.  [Reference - An under-the-hood peek at what the module is doing and how](#reference)
7.  [Limitations - OS compatibility, etc.](#limitations)
8.  [Development - Guide for contributing to the module](#development)
9.  [License](#License)

## Overview

This module manages InfluxDB installation.

[![Build Status](https://travis-ci.org/n1tr0g/golja-influxdb.png)](https://travis-ci.org/n1tr0g/golja-influxdb) [![Puppet Forge](http://img.shields.io/puppetforge/v/golja/influxdb.svg)](https://forge.puppetlabs.com/golja/influxdb)

## Module Description

The InfluxDB module manages both the installation and configuration of InfluxDB.
I am planning to extend it to allow management of InfluxDB resources,
such as databases, users, and privileges.

## Deprecation Warning

This release is a major refactoring of the module which means that the API
changed in backwards incompatible ways. If your project depends on the old API
and you need to use influxdb prior to 0.9.X, please pin your module
dependencies to 0.1.2 version to ensure your environments don't break.

*NOTE*: Until 1.0.0 release the API may change,
however I will try my best to avoid it.

## Installation

`puppet module install golja/influxdb`

## Setup

### What InfluxDB affects

*   InfluxDB packages
*   InfluxDB configuration files
*   InfluxDB service

### Beginning with InfluxDB

If you just want a server installed with the default options you can
run include `'::influxdb::server'`.

## Usage

All interaction for the server is done via `influxdb::server`.

Install influxdb

```puppet
class {'influxdb::server':}
```

Enable Graphite plugin

```puppet
class {'influxdb::server':
  graphite_enabled => true,
  graphite_tags    => ['region=us-east', 'zone=1c'],
}
```

Enable Collectd plugin

```puppet
class {'influxdb::server':
  collectd_enabled      => true,
  collectd_bind_address => ':2004',
  collectd_database     => 'collectd',
}
```

Enable UDP listener

```puppet
$udp_options = [
    { 'enabled'       => true,
      'bind-address'  => '":8089"',
      'database'      => '"udp_db1"',
      'batch-size'    => 10000,
      'batch-timeout' => '"1s"',
      'batch-pending' => 5,
    },
    { 'enabled'       => true,
      'bind-address'  => '":8090"',
      'database'      => '"udp_db2"',
      'batch-size'    => 10000,
      'batch-timeout' => '"1s"',
      'batch-pending' => 5,
    },
]

class {'influxdb::server':
	reporting_disabled    => true,
	http_auth_enabled     => true,
	version               => '0.9.4.2',
	shard_writer_timeout  => '10s',
	cluster_write_timeout => '10s',
	udp_options           => $udp_options,
}
```


## Reference

### Classes

#### Public classes

*   `influxdb::server`: Installs and configures InfluxDB.

#### Private classes

*   `influxdb::server::install`: Installs packages.
*   `influxdb::server::config`: Configures InfluxDB.
*   `influxdb::server::service`: Manages service.

### Parameters

#### influxdb::server

##### `ensure`

Allows you to install or remove InfluxDB. Can be 'present' or 'absent'.

##### `version`

Version of InfluxDB.
Default: 0.9.3
*NOTE*: Unfortunately, the latest link available on the influxdb website
is pointing to an old version.
For more info, check [ISSUE 3533](https://github.com/influxdb/influxdb/issues/3533)

##### `config_file`

Path to the config file.
Default: OS specific

##### `service_provider`

The provider to use to manage the service.
Default: OS specific

##### `service_enabled`

Boolean to decide if the service should be enabled.

##### `package_provider`

What provider should be used to install the package.

##### `hostname`

Server hostname used for clustering.
Default: undef

##### `bind_address`

This setting can be used to configure InfluxDB to bind to and listen for
connections from applications on this address.
If not specified, the module will use the default for your OS distro.

##### `reporting_disabled`

If enabled once every 24 hours InfluxDB will report anonymous data
to m.influxdb.com.
Default: false

##### `retention_autocreate`

Default: true

##### `election_timeout`

Default: 1s

##### `heartbeat_timeout`

Default: 1s

##### `leader_lease_timeout`

Default: 500ms

##### `commit_timeout`

Default: 50ms

##### `data_dir`

Controls where the actual shard data for InfluxDB lives.
Default: OS distro

##### `wal_dir`

Wal dir for the storage engine 0.9.3+
Default: /var/opt/influxdb/wal

##### `meta_dir`

Location of the meta dir
Default: /var/opt/influxdb/meta

##### `wal_enable_logging`

Enable WAL logging.
NEW in 0.9.3+
Default: true

##### `wal_ready_series_size`

When a series in the WAL in-memory cache reaches this size in bytes it is
marked as ready to flush to the index.
NEW in 0.9.3+
Default: 25600

##### `wal_compaction_threshold`

Flush and compact a partition once this ratio of series are over the ready size.
NEW in 0.9.3+
Default: 0.6

##### `wal_max_series_size`

Force a flush and compaction if any series in a partition
gets above this size in bytes.
NEW in 0.9.3+
Default: 2097152

##### `wal_flush_cold_interval`

Force a flush of all series and full compaction if there have been
no writes in this amount of time.
This is useful for ensuring that shards that are cold for writes
don't keep a bunch of data cached in memory and in the WAL.
NEW in 0.9.3+
Default: 10m

##### `wal_partition_size_threshold`

Force a partition to flush its largest series if it reaches
this approximate size in bytes.
Remember there are 5 partitions so you'll need at least
5x this amount of memory. The more memory you have, the bigger this can be.
NEW in 0.9.3+Default: 20971520

##### `max_wal_size`

Maximum size the WAL can reach before a flush.
*DEPRECATED* since version 0.9.3.
Default: 100MB

##### `wal_flush_interval`

Maximum time data can sit in WAL before a flush.
*DEPRECATED* since version 0.9.3.
Default: 10m

##### `wal_partition_flush_delay`

The delay time between each WAL partition being flushed.
*DEPRECATED* since version 0.9.3.
Default: 2s

##### `shard_writer_timeout`

The time within which a shard must respond to write.
Default: 5s

##### `cluster_write_timeout`

The time within which a write operation must complete on the cluster.
Default: 5s

##### `retention_enabled`

Controls the enforcement of retention policies for evicting old data.
Default: true

##### `retention_check_interval`

Default: 10m

##### `admin_enabled`

Controls the availability of the built-in, web-based, admin interface.
Default: true

##### `admin_bind_address`

Default: :8083

##### `admin_https_enabled`

If HTTPS is enabled for the admin interface,
HTTPS must also be enabled on the \[http\] service.
Default: false

##### `admin_https_certificate`

Default: undef

##### `http_enabled`

Controls how the HTTP endpoints are configured.
These are the primary mechanism for getting data into and out of InfluxDB.
Default: true

##### `http_bind_address`

Default: :8086

##### `http_auth_enabled`

Default: false

##### `http_log_enabled`

Default: true

##### `http_write_tracing`

Default: false

##### `http_pprof_enabled`

Default: false

##### `http_https_enabled`

Default: false

##### `http_https_certificate`

Default: undef

##### `graphite_enabled`

Controls one or many listeners for Graphite data.
Default: false

##### `graphite_bind_address`

Default: :2003

##### `graphite_protocol`

Default: tcp

##### `graphite_consistency_level`

Default: one

##### `graphite_separator`

Default: .

##### `graphite_tags`

The "measurement" tag is special and the corresponding field
will become the name of the metric.
Default: \[undef\]

##### `graphite_templates`

Default: false

##### `graphite_ignore_unnamed`

If set to true, when the input metric name has more fields than `name-schema`
specified, the extra fields will be ignored.
Default: true

##### `collectd_enabled`

Controls the listener for collectd data.
Default: false

##### `collectd_bind_address`

Default: undef

##### `collectd_database`

Default: undef

##### `collectd_typesdb`

Default: undef

##### `opentsdb_enabled`

Controls the listener for OpenTSDB data.
Default: false

##### `opentsdb_bind_address`

Default: undef

##### `opentsdb_database`

Default: undef

##### `opentsdb_retention_policy`

Default: undef

##### `udp_options`

Controls the listener for InfluxDB line protocol data via UDP.
Default: undef

##### `monitoring_enabled`

Default: true

##### `monitoring_write_interval`

Default: 24h

##### `continuous_queries_enabled`

Controls how continuous queries are run within InfluxDB.
Default: true

##### `continuous_queries_recompute_previous_n`

Default: 2

##### `continuous_queries_recompute_no_older_than`

Default: 10m

##### `continuous_queries_compute_runs_per_interval`

Default: 10

##### `continuous_queries_compute_no_more_than`

Default: 2m

##### `hinted_handoff_enabled`

Controls the hinted handoff feature, which allows nodes to temporarily
store queued data when one node of a cluster is down for a short period of time.
Default: true

##### `hinted_handoff_dir`

Default: OS specific

##### `hinted_handoff_max_size`

Default: 1073741824

##### `hinted_handoff_max_age`

Default: 168h

##### `hinted_handoff_retry_rate_limit`

Default: 0

##### `hinted_handoff_retry_interval`

Default: 1s

##### `conf_template`

If needed, you can add a custom template.
Default: influxdb/influxdb.conf.erb

##### `influxdb_user`

Default: OS specific

##### `influxdb_group`

Default: OS specific

##### `enable_snapshot`

Default: false

##### `influxdb_stderr_log`

Default: /var/log/influxdb/influxd.log

##### `influxdb_stdout_log`

Default: /dev/null

##### `manage_install`

enable/disable installation of the influxdb packages
Default: true

##### `influxd_opts`

Additional influxd options used for setting up raft clusters.
Default: undef

## Limitations

This module has been tested on:

*   Ubuntu 12.04
*   Ubuntu 14.04
*   CentOS 6/7

## Development

Please see CONTRIBUTING.md

### Todo

*   Add native types for managing users and databases
*   Add more rspec tests
*   Add beaker/rspec tests

## License

See LICENSE file
