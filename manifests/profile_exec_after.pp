# == Class: duplicity::profile_exec_after
#
# Add a script / command to be executed after the backup has run.
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
#   Set content to be executed after the backup.
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
define duplicity::profile_exec_after(
  String $ensure = present,
  String $profile = 'backup',
  Optional[String] $content = undef,
  Optional[String] $source = undef,
  String $order = '10',
) {
  require duplicity::params

  if $ensure !~ /^present|absent$/ {
    fail("Duplicity::Profile_Exec_After[${title}]: ensure must be either present or absent, got '${ensure}'")
  }

  if $profile !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Duplicity::Profile_Exec_After[${title}]: profile must be alphanumeric including dot, dash and underscore; got '${profile}'")
  }

  $profile_config_dir = "${duplicity::params::duply_config_dir}/${profile}"
  $profile_post_script = "${profile_config_dir}/${duplicity::params::duply_profile_post_script_name}"

  if $ensure == 'present' {
    concat::fragment { "profile-exec-after/${title}":
      target  => $profile_post_script,
      content => $content,
      source  => $source,
      order   => $order,
    }
  }
}
