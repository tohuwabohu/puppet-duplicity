# == Class: duplicity::file
#
# A file or directory to be included in the backup. If the file is not existing, it will be restored from the backup.
#
# === Parameters
#
# [*ensure*]
#   Set state the file should be in: either present (= backup and restore if not existing), backup (= backup only),
#   or absent.
#
# [*path*]
#   Set full path to the file or directory to be included in the backup.
#
# [*exclude*]
#   List of files or directories to be excluded from the backup.
#
# [*profile*]
#   Set the name of the profile to which the file should belong to.
#
# [*creates*]
#   Set full path of the file that is created by restoring this file or directory. Defaults to the path itself.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
define duplicity::file(
  $ensure  = present,
  $path    = $title,
  $exclude = [],
  $profile = 'backup',
  $creates = undef,
) {
  require duplicity::params

  if $ensure !~ /^present|backup|absent$/ {
    fail("Duplicity::File[${title}]: ensure must be either present, backup or absent, got '${ensure}'")
  }

  if $ensure =~ /^present$/ and $profile !~ /^[a-zA-Z0-9]+$/ {
    fail("Duplicity::File[${title}]: profile must be alphanumeric, got '${profile}'")
  }

  if !is_array($exclude) {
    fail("Duplicity::File[${title}]: exclude must be an array")
  }

  if !empty($creates) {
    validate_absolute_path($creates)
  }

  validate_absolute_path($path)

  $profile_dir = "${duplicity::params::duply_config_dir}/${profile}"
  $profile_filelist = "${profile_dir}/${duplicity::params::duply_profile_filelist_name}"
  $profile_filelist_ensure = $ensure ? {
    absent  => absent,
    default => present,
  }
  $exclude_filelist = join(regsubst($exclude, '^(.+)$', "- \\1\n"), '')
  $real_creates = pick($creates, $path)
  $path_md5 = md5($path)
  $path_without_slash = regsubst($path, '^/(.*)$', '\1')

  concat::fragment { "${profile_dir}/include/${path_md5}":
    ensure  => $profile_filelist_ensure,
    target  => $profile_filelist,
    content => "+ ${path}",
    order   => '15',
  }

  if !empty($exclude) {
    concat::fragment { "${profile_dir}/exclude/${path_md5}":
      ensure  => $profile_filelist_ensure,
      target  => $profile_filelist,
      content => $exclude_filelist,
      order   => '25',
    }
  }

  if $ensure == present {
    exec { "restore ${path}":
      command => "${duplicity::duply_executable} ${profile} fetch ${path_without_slash} ${path}",
      creates => $real_creates,
      require => File[$duplicity::duply_executable]
    }
  }
}
