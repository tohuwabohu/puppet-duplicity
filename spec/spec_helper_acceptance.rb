require 'beaker-rspec'
require 'beaker-puppet'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

# collection: puppet - latest, puppet6 is the current version
install_puppet_agent_on(hosts, {:puppet_collection => 'puppet' } )
install_module_on(hosts)
install_module_from_forge_on(hosts, 'puppetlabs-stdlib', '= 6.6.0')
install_module_from_forge_on(hosts, 'puppetlabs-concat', '= 6.4.0')
install_module_from_forge_on(hosts, 'puppet-archive', '= 4.6.0')
install_module_from_forge_on(hosts, 'puppet-logrotate', '= 5.0.0')

RSpec.configure do |c|
  c.formatter = :documentation

  c.before :suite do
    logger.info("Using Puppet version #{(on default, 'puppet --version').stdout.chomp}")
  end
end
