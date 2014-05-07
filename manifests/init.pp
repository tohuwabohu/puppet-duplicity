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
#   Set state the package should be in (if duply_package_provider is empty or not archive).
#
# [*duply_package_name*]
#   Set the name of the package to be installed.
#
# [*duply_package_provider*]
#   Set the provider used to install the duply package. Use archive to download a version from a remote host.
#
# [*duply_archive_md5sum*]
#   Set the MD5 checksum of the archive (if duply_package_provider is archive).
#
# [*duply_archive_url*]
#   Set the url where to download the archive from (if duply_package_provider is archive).
#
# [*duply_archive_package_dir*]
#   Sets the directory where the downloaded package is stored (if duply_package_provider is archive).
#
# [*duply_archive_install_dir*]
#   Sets the directory where the application is installed (if duply_package_provider is archive).
#
# [*duply_executable*]
#   Sets the path of the duply executable pointing to the one contained in the package (if duply_package_provider is archive).
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
  $duplicity_package_ensure  = params_lookup('duplicity_package_ensure'),
  $duplicity_package_name    = params_lookup('duplicity_package_name'),
  $duply_package_ensure      = params_lookup('duply_package_ensure'),
  $duply_package_name        = params_lookup('duply_package_name'),
  $duply_package_provider    = params_lookup('duply_package_provider'),
  $duply_archive_md5sum      = params_lookup('duply_archive_md5sum'),
  $duply_archive_url         = params_lookup('duply_archive_url'),
  $duply_archive_package_dir = params_lookup('duply_archive_package_dir'),
  $duply_archive_install_dir = params_lookup('duply_archive_install_dir'),
  $duply_executable          = params_lookup('duply_executable'),
) inherits duplicity::params {
  if empty($duplicity_package_ensure) {
    fail('Class[Duplicity]: duplicity_package_ensure must not be empty')
  }

  if $duplicity_package_name !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Class[Duplicity]: duplicity_package_name must be alphanumeric, got '${duplicity_package_name}'")
  }

  if empty($duply_package_ensure) {
    fail('Class[Duplicity]: duply_package_ensure must not be empty')
  }

  if $duply_package_name !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Class[Duplicity]: duply_package_name must be alphanumeric, got '${duply_package_name}'")
  }

  validate_absolute_path($duply_archive_package_dir)
  validate_absolute_path($duply_archive_install_dir)
  validate_absolute_path($duply_executable)

  class { 'duplicity::install': } ->
  class { 'duplicity::setup': }
}
