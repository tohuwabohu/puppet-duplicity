# == Class: duplicity::setup
#
# Complete the installation.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
class duplicity::setup inherits duplicity {
  include duplicity::params

  file { $duplicity::params::duply_config_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    backup  => false,
    purge   => true,
    force   => true,
    recurse => true,
  }
}
