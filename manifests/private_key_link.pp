# == Class: duplicity::private_key_link
#
# Configure a private key to be used by duplicity.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
define duplicity::private_key_link(
  String $ensure = present
) {
  require duplicity::params

  $values = split($title, '/')
  if count($values) != 2 {
    fail("Duplicity::Private_Key_Link[${title}]: title does not match expected format: <profile>/<keyid>; got '${title}'")
  }

  $profile = $values[0]
  if $profile !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Duplicity::Private_Key_Link[${title}]: profile must be alphanumeric including dot, dash and underscore; got '${profile}'")
  }
  $keyid = $values[1]
  if $keyid !~ /^[a-zA-Z0-9]+$/ {
    fail("Duplicity::Private_Key_Link[${title}]: keyid must be alphanumeric, got '${keyid}'")
  }

  file { "${duplicity::params::duply_config_dir}/${profile}/gpgkey.${keyid}.sec.asc":
    ensure  => link,
    target  => "${duplicity::params::duply_private_key_dir}/${keyid}.asc",
    require => Duplicity::Private_Key[$keyid],
  }
}
