# == Class: duplicity::profile
#
# Configure a backup profile.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
define duplicity::profile($ensure = present) {
  require duplicity::params

  $profile_config_dir = "${duplicity::params::duply_config_dir}/${name}"
  $profile_config_dir_ensure = $ensure ? {
    absent  => absent,
    default => directory,
  }
  $profile_config_file = "${profile_config_dir}/conf"
  $profile_config_file_ensure = $ensure ? {
    absent  => absent,
    default => file,
  }
  $profile_file_list_file = "${profile_config_dir}/exclude"
  $profile_file_list_file_ensure = $ensure ? {
    absent  => absent,
    default => file,
  }

  file { $profile_config_dir:
    ensure => $profile_config_dir_ensure,
    owner  => 'root',
    group  => 'root',
    mode   => '0444',
  }

  file { $profile_config_file:
    ensure  => $profile_config_file_ensure,
    content => template('duplicity/etc/duply/conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
  }

  file { $profile_file_list_file:
    ensure  => $profile_file_list_file_ensure,
    content => template('duplicity/etc/duply/exclude.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
  }
}
