# == Class: duplicity::params
#
# Default values of the duplicity class.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
class duplicity::params {
  $duplicity_package_ensure = installed
  $duplicity_package_name = 'duplicity'

  $duply_package_ensure = '1.7.3'
  $duply_package_name = 'duply-1.7.3'
  $duply_package_provider = archive
  $duply_archive_md5sum = '139e36c3ee35d8bca15b6aa9c7f8939b'
  $duply_archive_url = "https://www.dropbox.com/s/4m7pnp9hjxmq4gu/${duply_package_name}.tgz"
  $duply_archive_package_dir = $::operatingsystem ? {
    default => '/var/cache/puppet/archives',
  }
  $duply_archive_install_dir = $::operatingsystem ? {
    default => '/opt',
  }
  $duply_executable = $::operatingsystem ? {
    default => '/usr/local/bin/duply'
  }
}
