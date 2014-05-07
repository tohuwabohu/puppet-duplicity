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

  $duply_package_ensure = installed
  $duply_package_name = 'duply'
}
