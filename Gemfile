source ENV['GEM_SOURCE'] || 'https://rubygems.org'

group :development, :test do
  gem 'rake', '~> 12.0'
  gem 'rspec', '~> 3.5'
  gem 'rspec-puppet', '~> 2.4'
  gem 'puppetlabs_spec_helper', '~> 2.3'
  gem 'puppet-blacksmith', '~> 3.4'
  gem 'puppet-lint', '~> 2.0'
  gem 'metadata-json-lint', '~> 2.0'
  gem 'puppet-lint-unquoted_string-check', '~> 0.2'
  gem 'puppet-syntax', '~> 2.1'
end

group :system_tests do
  gem 'beaker', '~> 3.21'
  gem 'beaker-rspec', '~> 6.1'
  gem 'beaker-puppet_install_helper', '~> 0.7'
  gem 'beaker-module_install_helper', '~> 0.1'
end

if (puppetversion = ENV['PUPPET_VERSION'])
  gem 'puppet', puppetversion
else
  gem 'puppet', '~> 4.8'
end
