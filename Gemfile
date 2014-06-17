source ENV['GEM_SOURCE'] || "https://rubygems.org"

group :development, :test do
  gem 'rake', '~> 10.1.1'
  gem 'rspec', '~> 2.14.1'
  gem 'rspec-puppet', '~> 1.0.1'
  gem 'puppetlabs_spec_helper', '~> 0.4.1'
  gem 'puppet-syntax', '~> 1.1.1'
  gem 'puppet-lint', '~> 0.3.2'
end

if puppetversion = ENV['PUPPET_VERSION']
  gem 'puppet', puppetversion
else
  gem 'puppet'
end
