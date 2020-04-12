# == Class: duplicity::private_key
#
# Configure a private key to be used by duplicity.
#
# === Parameters
#
# [*ensure*]
#   Set state the private key should be in. Either present or absent.
#
# [*keyid*]
#   Set the keyid of the private key.
#
# [*content*]
#   Set content of the private key.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
define duplicity::private_key(
  Enum['present', 'absent'] $ensure = 'present',
  String $keyid = $title,
  Optional[String] $content = undef,
) {
  require duplicity::params

  if $ensure == 'present' {
    if $keyid !~ /^[a-zA-Z0-9]+$/ {
      fail("Duplicity::Private_Key[${title}]: keyid must be alphanumeric, got '${keyid}'")
    }

    if empty($content) {
      fail("Duplicity::Private_Key[${title}]: content must not be empty")
    }
  }

  $keyfile_ensure = $ensure ? {
    'absent' => 'absent',
    default  => 'file',
  }

  file { "${duplicity::params::duply_private_key_dir}/${keyid}.asc":
    ensure  => $keyfile_ensure,
    content => $content,
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
  }
}
