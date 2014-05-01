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
  $package_ensure = installed
  $package_name = 'duplicity'
}
