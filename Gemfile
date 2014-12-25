source ENV['GEM_SOURCE'] || 'https://rubygems.org'

group :development, :test do
  gem 'rake', '~> 10.1.1'
  gem 'rspec', '~> 2.14.1'
  gem 'rspec-puppet', '~> 1.0.1'
  gem 'puppetlabs_spec_helper', '~> 0.4.1'
  gem 'puppet-blacksmith', '~> 3.1.1'
  gem 'mime-types', '~> 1.25.0' # downgrade to work with Ruby 1.8.7
  gem 'puppet-lint', '~> 0.3.2'
  gem 'puppet-syntax', '~> 1.1.1'
end

if puppetversion = ENV['PUPPET_VERSION']
  gem 'puppet', puppetversion
else
  gem 'puppet', '~> 3.7.3'
end
