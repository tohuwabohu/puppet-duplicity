require 'beaker-rspec'
require 'beaker-puppet'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

run_puppet_install_helper
install_module_on(hosts)
install_module_from_forge_on(hosts, 'puppetlabs-stdlib', '= 4.15.0')
install_module_from_forge_on(hosts, 'puppetlabs-concat', '= 5.0.0')
install_module_from_forge_on(hosts, 'camptocamp-archive', '= 0.9.0')
install_module_from_forge_on(hosts, 'yo61-logrotate', '= 1.4.0')

RSpec.configure do |c|
  c.formatter = :documentation

  c.before :suite do
    logger.info("Using Puppet version #{(on default, 'puppet --version').stdout.chomp}")
  end
end
