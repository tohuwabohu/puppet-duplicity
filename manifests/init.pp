# == Class: duplicity
#
# Install and manage duplicity.
#
# === Parameters
#
# [*duplicity_package_ensure*]
#   Set state the package should be in.
#
# [*duplicity_package_name*]
#   Set the name of the package to be installed.
#
# [*duply_package_ensure*]
#   Set state the package should be in.
#
# [*duply_package_name*]
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
  $duplicity_package_ensure = params_lookup('duplicity_package_ensure'),
  $duplicity_package_name   = params_lookup('duplicity_package_name'),
  $duply_package_ensure     = params_lookup('duply_package_ensure'),
  $duply_package_name       = params_lookup('duply_package_name')
) inherits duplicity::params {

  if empty($duplicity_package_ensure) {
    fail("Class[Duplicity]: duplicity_package_ensure must not be empty")
  }

  if $duplicity_package_name !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Class[Duplicity]: duplicity_package_name must be alphanumeric, got '${duplicity_package_name}'")
  }

  if empty($duply_package_ensure) {
    fail("Class[Duplicity]: duply_package_ensure must not be empty")
  }

  if $duply_package_name !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Class[Duplicity]: duply_package_name must be alphanumeric, got '${duply_package_name}'")
  }

  class { 'duplicity::install': }
}
