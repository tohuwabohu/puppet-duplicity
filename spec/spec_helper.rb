RSpec.configure do |c|
  c.mock_with :rspec
end

require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.default_facts = {
    # concat
    :concat_basedir            => '/path/to/dir',
    :id                        => 'deadbeef',
    :kernel                    => 'deadbeef',
    :path                      => '/usr/bin',

    :operatingsystem           => 'Debian',
    :osfamily                  => 'Debian',
    :os                        => {
        :family => 'Debian',
        :name   => 'Debian',
        :release => {
            :major => '8'
        }
    },
    :lsbmajdistrelease         => '8',
    :operatingsystemmajrelease => '8',
  }
end
