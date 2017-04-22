# == Class: duplicity::profile_exec_before
#
# Add a script / command to be executed before the backup runs.
#
# === Parameters
#
# [*ensure*]
#   Set state of the fragment: either present or absent.
#
# [*profile*]
#   Set the name of the duplicity profile.
#
# [*content*]
#   Set content to be executed before the backup.
#
# [*source*]
#   Set the source which is used in the absence of `content`.
#
# [*order*]
#   Set order of the fragment.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
define duplicity::profile_exec_before(
  $ensure  = present,
  $profile = 'backup',
  $content = undef,
  $source  = undef,
  $order   = '10',
) {
  require duplicity::params

  if $ensure !~ /^present|absent$/ {
    fail("Duplicity::Profile_Exec_Before[${title}]: ensure must be either present or absent, got '${ensure}'")
  }

  if $profile !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Duplicity::Profile_Exec_Before[${title}]: profile must be alphanumeric including dot, dash and underscore; got '${profile}'")
  }

  $profile_config_dir = "${duplicity::params::duply_config_dir}/${profile}"
  $profile_pre_script = "${profile_config_dir}/${duplicity::params::duply_profile_pre_script_name}"

  if $ensure == 'present' {
    concat::fragment { "profile-exec-before/${title}":
      target  => $profile_pre_script,
      content => $content,
      source  => $source,
      order   => $order,
    }
  }
}
