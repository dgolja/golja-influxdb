source ENV['GEM_SOURCE'] || 'https://rubygems.org'

def location_for(place, fake_version = nil)
  if place =~ /^(git[:@][^#]*)#(.*)/
    [fake_version, { :git => $1, :branch => $2, :require => false }].compact
  elsif place =~ /^file:\/\/(.*)/
    ['>= 0', { :path => File.expand_path($1), :require => false }]
  else
    [place, { :require => false }]
  end
end

ruby_ver = RUBY_VERSION.gsub(/\./, "").to_i
if ruby_ver < 225
  ENV['BEAKER_VERSION'].nil? ? ENV['BEAKER_VERSION'] = '2.51.0' : nil
else
  ENV['BEAKER_VERSION'].nil? ? ENV['BEAKER_VERSION'] = '3.10.0' : nil
end

group :development, :test do
  gem 'rake',                        require: false
  gem 'rspec',                       require: false
  gem 'rspec-puppet',                require: false
  gem 'puppetlabs_spec_helper',      require: false
  gem 'puppet-lint',                 require: false
  gem 'simplecov',                   require: false
  gem 'puppet_facts',                require: false
  gem 'json_pure', '~> 1.8',         require: false
  gem 'json',                        require: false
  gem 'rspec-puppet-facts',          require: false
  gem 'metadata-json-lint', '1.2.2', require: false if RUBY_VERSION.to_f == 2.1
  gem 'metadata-json-lint', '1.1.0', require: false if RUBY_VERSION.to_f <= 1.9
  gem 'rubocop', '~> 0.47.0',        require: false if RUBY_VERSION >= '2.3.0'
  gem 'rubocop-rspec', '~> 1.10.0',  require: false if RUBY_VERSION >= '2.3.0'
end

group :system_tests do
  gem 'beaker',                        *location_for(ENV['BEAKER_VERSION'] || '~> 2.0')
  gem 'beaker-rspec',                  require: false
  gem 'beaker_spec_helper',            require: false
  gem 'beaker-hiera',                  require: false
  gem 'beaker-puppet_install_helper',  require: false
  gem 'serverspec',                    require: false
end

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, require: false
else
  gem 'facter', require: false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, require: false
else
  gem 'puppet', require: false
end

# vim:ft=ruby
