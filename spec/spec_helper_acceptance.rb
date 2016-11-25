require 'beaker-rspec/spec_helper'
require 'beaker/puppet_install_helper'

run_puppet_install_helper

RSpec.configure do |c|
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  c.formatter = :documentation
  c.before :suite do
    puppet_module_install(:source => proj_root, :module_name => 'duplicity')
    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib', '--version 4.3.2')
      on host, puppet('module', 'install', 'puppetlabs-concat', '--version 1.1.0')
      on host, puppet('module', 'install', 'camptocamp-archive', '--version 0.7.4')
      on host, puppet('module', 'install', 'yo61-logrotate', '--version 1.3.0')
    end
  end
end
