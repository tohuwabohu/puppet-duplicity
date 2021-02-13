source ENV['GEM_SOURCE'] || 'https://rubygems.org'

group :development, :test do
  gem 'rake', '~> 13.0'
  gem 'rspec', '~> 3.5'
  gem 'rspec-puppet', '~> 2.4'
  gem 'pdk', '~> 1.17'
  gem 'puppetlabs_spec_helper', '~> 3.0'
  gem 'puppet-blacksmith', '~> 6.1'
  gem 'puppet-lint', '~> 2.0'
  gem 'metadata-json-lint', '~> 3.0'
  gem 'puppet-lint-unquoted_string-check', '~> 2.0'
  gem 'puppet-syntax', '~> 3.1'
end

group :system_tests do
  gem 'beaker', '~> 4.0'
  gem 'beaker-rspec', '~> 6.2'
  gem 'beaker-puppet', '~> 1.18'
  gem 'beaker-docker', '~> 0.7'
  gem 'beaker-puppet_install_helper', '~> 0.9'
  gem 'beaker-module_install_helper', '~> 0.1'
end

if (puppetversion = ENV['PUPPET_VERSION'])
  gem 'puppet', puppetversion
else
  gem 'puppet', '~> 7.0'
end
