# == Class: duplicity
#
# Install and manage duplicity.
#
# === Parameters
#
# [*package_ensure*]
#   Set state the package should be in.
#
# [*package_name*]
#   Set the name of the package to be installed.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
class duplicity (
  $package_ensure = params_lookup('package_ensure'),
  $package_name   = params_lookup('package_name')
) inherits duplicity::params {

  if $package_ensure !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Class[Duplicity]: package_ensure must be alphanumeric, got '${package_ensure}'")
  }

  if $package_name !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Class[Duplicity]: package_name must be alphanumeric, got '${package_name}'")
  }

  package { 'duplicity':
    ensure   => $package_ensure,
    name     => $package_name,
  }
}
