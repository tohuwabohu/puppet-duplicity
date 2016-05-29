# == Class: duplicity::public_key
#
# Configure a public key to be used by duplicity.
#
# === Parameters
#
# [*ensure*]
#   Set state the public key should be in. Either present or absent.
#
# [*keyid*]
#   Set the keyid of the public key.
#
# [*content*]
#   Set content of the public key.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
define duplicity::public_key(
  $ensure  = present,
  $keyid   = $title,
  $content = undef,
) {
  require duplicity::params

  if $ensure !~ /^present|absent$/ {
    fail("Duplicity::Public_Key[${title}]: ensure must be either present or absent, got '${ensure}'")
  }

  if $ensure =~ /^present$/ and $keyid !~ /^[a-zA-Z0-9]+$/ {
    fail("Duplicity::Public_Key[${title}]: keyid must be alphanumeric, got '${keyid}'")
  }

  if $ensure =~ /^present$/ and empty($content) {
    fail("Duplicity::Public_Key[${title}]: content must not be empty")
  }

  $keyfile_ensure = $ensure ? {
    'absent' => absent,
    default  => file,
  }

  file { "${duplicity::params::duply_public_key_dir}/${keyid}.asc":
    ensure  => $keyfile_ensure,
    content => $content,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
  }
}
