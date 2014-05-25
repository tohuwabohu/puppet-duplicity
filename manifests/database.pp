# == Define: duplicity::database
#
# Create a backup of the named database.
#
# === Parameters
#
# [*ensure*]
#   Set state the package should be in. Can be either present or absent.
#
# [*database*]
#   Set the name of the database.
#
# [*type*]
#   Set the database type. The type must be supported by the module to work.
#
# [*profile*]
#   Set the name of the duplicity profile where the database is added to.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
define duplicity::database(
  $ensure = present,
  $database = $title,
  $type = undef,
  $profile = undef,
) {
  require duplicity

  if $ensure !~ /^present|absent$/ {
    fail("Duplicity::Database[${title}]: ensure must be either present or absent, got '${ensure}'")
  }
  if $type !~ /^mysql|postgres$/ {
    fail("Duplicity::Database[${title}]: type must be either mysql or postgres, got '${type}'")
  }
  if empty($profile) {
    fail("Duplicity::Database[${title}]: profile must not be empty")
  }

  $profile_dir = "${duplicity::params::duply_config_dir}/${profile}"
  $profile_pre_script = "${profile_dir}/${duplicity::params::duply_profile_pre_script_name}"
  $profile_filelist = "${profile_dir}/${duplicity::params::duply_profile_filelist_name}"
  $dump_script_path = downcase($type) ? {
    'mysql'    => $duplicity::database::mysql::dump_script_path,
    'postgres' => $duplicity::database::postgres::dump_script_path,
    default    => undef,
  }
  $dump_file = downcase($type) ? {
    'mysql'    => "${duplicity::database::mysql::backup_dir}/${database}.sql.gz",
    'postgres' => "${duplicity::database::postgres::backup_dir}/${database}.sql.gz",
    default    => undef,
  }

  concat::fragment { "${profile_pre_script}${type}/${database}":
    target  => $profile_pre_script,
    content => "${dump_script_path} ${database}\n",
    order   => '10',
  }
  duplicity::file { $dump_file:
    ensure  => backup,
    profile => $profile
  }
}
