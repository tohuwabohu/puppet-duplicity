# = Class: duplicity::install
#
# Installs duplicity and duply.
#
# == Author
#
#   Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
class duplicity::install inherits duplicity {

  package { 'duplicity':
    ensure => $duplicity::duplicity_package_ensure,
    name   => $duplicity::duplicity_package_name,
  }

  package { 'duply':
    ensure => $duplicity::duply_package_ensure,
    name   => $duplicity::duply_package_name,
  }
}
