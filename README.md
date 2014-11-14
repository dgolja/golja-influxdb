# influxdb

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with influxdb](#setup)
    * [What influxdb affects](#what-influxdb-affects)
    * [Beginning with influxdb](#beginning-with-influxdb)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview


## Module Description


## Setup

### What influxdb affects

### Beginning with influxdb

## Usage

### Add input_plugins.graphite

   class {'influxdb':
     input_plugins => {
       'input_plugins.graphite' => {
          'enabled'             => false,
          'address'             => '0.0.0.0',
          'port'                => 2003,
          'database'            => 'graphitedb',
          'udp_enabled'         => true,
        }
     }
   }

## Reference

## Limitations

## Development

