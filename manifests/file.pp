# == Class: duplicity::file
#
# A file or directory to be included in the backup. If the file is not existing, it will be restored from the backup.
#
# === Parameters
#
# [*ensure*]
#   Set state the file should be in: either `present` (= backup and restore if not existing), `backup (= backup only),
#   or `absent` (= remove file or directory from backup at all, do not attempt to restore it).
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
# [*timeout*]
#   Set the maximum time the restore should take. If the restore takes longer than the timeout, it is considered to
#   have failed and will be stopped. The timeout is specified in seconds. The default timeout is 300 seconds and you
#   can set it to 0 to disable the timeout.
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
  $profile = 'system',
  $timeout = 300,
) {
  require duplicity

  if $ensure !~ /^present|backup|absent$/ {
    fail("Duplicity::File[${title}]: ensure must be either present, backup or absent, got '${ensure}'")
  }

  if $ensure =~ /^present$/ and $profile !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Duplicity::File[${title}]: profile must be alphanumeric including dot, dash and underscore; got '${profile}'")
  }

  if !is_array($exclude) {
    fail("Duplicity::File[${title}]: exclude must be an array")
  }

  validate_absolute_path($path)

  $profile_dir = "${duplicity::params::duply_config_dir}/${profile}"
  $profile_filelist = "${profile_dir}/${duplicity::params::duply_profile_filelist_name}"
  $profile_filelist_ensure = $ensure ? {
    absent  => absent,
    default => present,
  }
  $exclude_filelist = join(prefix($exclude, '- '), "\n")
  $path_md5 = md5($path)
  $path_without_slash = regsubst($path, '^/(.*)$', '\1')

  if !empty($exclude) {
    concat::fragment { "${profile_dir}/exclude/${path_md5}":
      ensure  => $profile_filelist_ensure,
      target  => $profile_filelist,
      content => $exclude_filelist,
      order   => '25',
    }
  }

  concat::fragment { "${profile_dir}/include/${path_md5}":
    ensure  => $profile_filelist_ensure,
    target  => $profile_filelist,
    content => "+ ${path}",
    order   => '75',
  }

  if $ensure == present {
    exec { "restore ${path}":
      command => "duply ${profile} fetch \"${path_without_slash}\" \"${path}\"",
      path    => $duplicity::exec_path,
      creates => $path,
      timeout => $timeout,
      require => Duplicity::Profile[$profile],
    }
  }
}
