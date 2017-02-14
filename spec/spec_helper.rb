require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts

$DEFINED_REPOS = {
  'Debian' => {
    'contain'     => 'influxdb::repo::apt',
    'not_contain' => 'influxdb::repo::yum',
  },
  'RedHat' => {
    'contain'     => 'influxdb::repo::yum',
    'not_contain' => 'influxdb::repo::apt',
  }
}

def get_repo_contain_class(facts)
  osfam = facts[:osfamily].to_s

  $DEFINED_REPOS[osfam]['contain']
end

def get_repo_not_contain_class(facts)
  osfam = facts[:osfamily].to_s

  $DEFINED_REPOS[osfam]['not_contain']
end

# Include code coverage report for all our specs
at_exit { RSpec::Puppet::Coverage.report! }
