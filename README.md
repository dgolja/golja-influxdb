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

[![Build Status](https://travis-ci.org/n1tr0g/golja-influxdb.png)](https://travis-ci.org/n1tr0g/golja-influxdb) [![Puppet Forge](http://img.shields.io/puppetforge/v/golja/influxdb.svg)](https://forge.puppetlabs.com/golja/influxdb)


##Module Description

The InfluxDB module manages both the installation and configuration of InfluxDB. I am planning to extend it to
allow management of InfluxDB resources, such as databases, users, and privileges.

##Deprecation Warning

This release is a major refactoring of the module which means that the API changed in backwards incompatible ways. If your project depends on the old API and you need to use influxdb prior to 0.9.X, please pin your module dependencies to 0.1.2 version to ensure your environments don't break.

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

###Install influxdb

```puppet
class {'influxdb::server':}
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

Version of InfluxDB. Default: 0.9.2
*NOTE*: Unfortunatelly the lastest link available on the influxdb webiste is pointing to an old version. For
more info check [ISSUE 3533](https://github.com/influxdb/influxdb/issues/3533)

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

#####`retention_autocreate`

Default: true

#####`election_timeout`

Default: 1s

#####`heartbeat_timeout`

Default: 1s

#####`leader_lease_timeout`

Default: 500ms

#####`commit_timeout`

Default: 50ms

#####`data_dir`

Controls where the actual shard data for InfluxDB lives. Default: OS distro

#####`max_wal_size`

Maximum size the WAL can reach before a flush. Default: 100MB

#####`wal_flush_interval`

Maximum time data can sit in WAL before a flush. Default: 10m

#####`wal_partition_flush_delay`

The delay time between each WAL partition being flushed. Default: 2s

#####`shard_writer_timeout`

The time within which a shard must respond to write. Default: 5s

#####`cluster_write_timeout`

The time within which a write operation must complete on the cluster. Default: 5s

#####`retention_enabled`

Controls the enforcement of retention policies for evicting old data. Default: true

#####`retention_check_interval`

Default: 10m

#####`admin_enabled`

Controls the availability of the built-in, web-based admin interface. Default: true

#####`admin_bind_address`

Default: :8083

#####`admin_https_enabled`

If HTTPS is enabled for the admin interface, HTTPS must also be enabled on the [http] service. Default: false

#####`admin_https_certificate`

Default: undef

#####`http_enabled`

Controls how the HTTP endpoints are configured. These are the primary mechanism for getting data into and out of InfluxDB. Default true

#####`http_bind_address`

Default: :8086

#####`http_auth_enabled`

Default: false

#####`http_log_enabled`

Default: true

#####`http_write_tracing`

Default: false

#####`http_pprof_enabled`

Default: false

#####`http_https_enabled`

Default: false

#####`http_https_certificate`

Default: undef

#####`graphite_enabled`

Controls one or many listeners for Graphite data. Default: false

#####`graphite_bind_address`

Default: :2003

#####`graphite_protocol`

Default: tcp

#####`graphite_consistency_level`

Default: one

#####`graphite_separator`

Default: .

#####`graphite_tags`

The "measurement" tag is special and the corresponding field will become the name of the metric. Default: [undef]

#####`graphite_templates`

Default: false

#####`graphite_ignore_unnamed`

If set to true, when the input metric name has more fields than `name-schema` specified, the extra fields will be ignored. Default: true

#####`collectd_enabled`

Controls the listener for collectd data. Default: false

#####`collectd_bind_address`

Default: undef

#####`collectd_database`

Default: undef

#####`collectd_typesdb`

Default: undef

#####`opentsdb_enabled`

Controls the listener for OpenTSDB data. Default: false

#####`opentsdb_bind_address`

Default: undef

#####`opentsdb_database`

Default: undef

#####`opentsdb_retention_policy`

Default: undef

#####`udp_enabled`

Controls the listener for InfluxDB line protocol data via UDP. Default: false

#####`udp_bind_address`

Default: undef

#####`udp_database`

Default: undef

#####`udp_batch_size`

Default: 0

#####`udp_batch_timeout`

Default: 0

#####`monitoring_enabled`

Default: true

#####`monitoring_write_interval`

Default: 24h

#####`continuous_queries_enabled`

Controls how continuous queries are run within InfluxDB. Default: true

#####`continuous_queries_recompute_previous_n`

Default: 2

#####`continuous_queries_recompute_no_older_than`

Default: 10m

#####`continuous_queries_compute_runs_per_interval`

Default: 10

#####`continuous_queries_compute_no_more_than`

Default: 2m

#####`hinted_handoff_enabled`

Controls the hinted handoff feature, which allows nodes to temporarily store queued
data when one node of a cluster is down for a short period of time. Default: true

#####`hinted_handoff_dir`

Default: OS speficis

#####`hinted_handoff_max_size`

Default: 1073741824

#####`hinted_handoff_max_age`

Default: 168h

#####`hinted_handoff_retry_rate_limit`

Default: 0

#####`hinted_handoff_retry_interval`

Default: 1s

#####`conf_template`

If needed you can add a custom template. Default: influxdb/influxdb.conf.erb

#####`influxdb_user`

Default: OS specific

#####`influxdb_group`

Default: OS specific


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
