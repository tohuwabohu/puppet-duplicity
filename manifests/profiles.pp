# == Class: duplicity::profiles
#
# Configure profiles from a hash.
#
# === Parameters
#
# [*profiles*]
#   A hash with profiles to create through duplicity::profile
# === Authors
#
# Jochem van Dieten <jochem@vandieten.net>
#
# === Copyright
#
# Copyright 2017 Jochem van Dieten
#
class duplicity::profiles(
  $profiles = {},
) {
  include ::duplicity
  create_resources('duplicity::profile', $profiles)
}
