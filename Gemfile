source ENV['GEM_SOURCE'] || 'https://rubygems.org'

group :development, :test do
  gem 'rake', '~> 13.0'
  gem 'rspec', '~> 3.5'
  gem 'rspec-puppet', '~> 4.0'
  gem 'pdk', '~> 3.0'
  gem 'puppetlabs_spec_helper', '~> 7.0'
  gem 'puppet-blacksmith', '~> 6.1'
  gem 'puppet-lint', '~> 4.0'
  gem 'metadata-json-lint', '~> 4.0'
  gem 'puppet-lint-unquoted_string-check', '~> 3.0'
  gem 'puppet-syntax', '~> 3.1'
end

group :system_tests do
  gem 'beaker', '~> 4.0'
  gem 'beaker-rspec', '~> 8.0'
  gem 'beaker-puppet', '~> 2.0'
  gem 'beaker-docker', '~> 2.1.0'
  gem 'beaker-puppet_install_helper', '~> 0.9'
  gem 'beaker-module_install_helper', '~> 2.0'
  gem 'voxpupuli-acceptance', '~> 1.0'
end

if (puppetversion = ENV['PUPPET_VERSION'])
  gem 'puppet', puppetversion
else
  gem 'puppet', '~> 8.0'
end
