source ENV['GEM_SOURCE'] || 'https://rubygems.org'

group :development, :test do
  gem 'rake', '~> 10.1.1'
  gem 'rspec', '~> 2.14.1'
  gem 'rspec-puppet', '~> 1.0.1'
  gem 'puppetlabs_spec_helper', '~> 0.8.2'
  gem 'puppet-blacksmith', '~> 3.1.1'
  gem 'rest-client', '~> 1.6.7' # Ruby 1.8.7 compatible version
  gem 'mime-types', '< 2.0'
  gem 'puppet-lint', '~> 1.1.0'
  gem 'puppet-syntax', '~> 1.1.1'
end

if puppetversion = ENV['PUPPET_VERSION']
  gem 'puppet', puppetversion
else
  gem 'puppet', '~> 3.7.3'
end
