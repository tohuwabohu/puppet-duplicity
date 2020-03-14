require 'beaker-rspec'
require 'beaker-puppet'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

run_puppet_install_helper
install_module_on(hosts)
install_module_from_forge_on(hosts, 'puppetlabs-stdlib', '= 5.2.0')
install_module_from_forge_on(hosts, 'puppetlabs-concat', '= 5.3.0')
install_module_from_forge_on(hosts, 'puppet-archive', '= 3.2.1')
install_module_from_forge_on(hosts, 'puppet-logrotate', '= 3.4.0')

RSpec.configure do |c|
  c.formatter = :documentation

  c.before :suite do
    logger.info("Using Puppet version #{(on default, 'puppet --version').stdout.chomp}")
  end
end
