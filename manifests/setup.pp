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

  file { $duplicity::params::duply_key_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    backup  => false,
    purge   => true,
    force   => true,
    recurse => true,
  }

  file { $duplicity::params::duply_public_key_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { $duplicity::params::duply_private_key_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
  }

  logrotate::rule { 'duplicity':
    ensure       => present,
    path         => $duplicity::duplicity_log_file,
    rotate       => 5,
    size         => '100k',
    compress     => true,
    missingok    => true,
    create       => true,
    create_owner => 'root',
    create_group => 'adm',
    create_mode  => '0640',
  }
}
