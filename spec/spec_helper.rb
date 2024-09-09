RSpec.configure do |c|
  c.mock_with :rspec
end

require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.default_facts = {
    # default
    :networking                => {
      :ip => '127.0.0.1'
    },
    # concat
    :concat_basedir            => '/path/to/dir',
    :id                        => 'deadbeef',
    :kernel                    => 'deadbeef',
    :path                      => '/usr/bin',

    :os                        => {
      :family => 'Debian',
      :name   => 'Debian',
      :release => {
        :major => '10'
      }
    },
  }
end
