source ENV['GEM_SOURCE'] || "https://rubygems.org"

puppetversion = ENV.key?('PUPPET_VERSION') ? "= #{ENV['PUPPET_VERSION']}" : ['>= 3.3']

group :development, :test do
  gem 'rake',                    :require => false
  gem 'rspec-puppet',            :require => false
  gem 'puppetlabs_spec_helper',  :require => false
  gem 'serverspec',              :require => false
  gem 'puppet-lint',             :require => false
  gem 'beaker-rspec',            :require => false
  gem 'puppet_facts',            :require => false
  gem 'rspec-system-puppet',     '~>2.0'
end

gem 'puppet', puppetversion
gem 'facter', '>= 1.7.0'

# vim:ft=ruby
