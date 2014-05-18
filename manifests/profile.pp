# == Class: duplicity::profile
#
# Configure a backup profile.
#
# === Parameters
#
# [*ensure*]
#   Set state the profile should be in. Either present or absent.
#
# [*gpg_encryption_keys*]
#   List of public keyids used to encrypt the backup.
#
# [*gpg_signing_key*]
#   Set the keyid of the key used to sign the backup.
#
# [*gpg_passphrase*]
#   Set the passphrase needed for signing, decryption and symmetric encryption.
#
# [*gpg_options*]
#   List of options passed from duplicity to the gpg process.
#
# [*source*]
#   Set the base directory to backup.
#
# [*target*]
#   Set the target where to store / find the backups. Expected to be an url like scheme://host[:port]/[/]path.
#
# [*target_username*]
#   Set the username used to authenticate with the target.
#
# [*target_password*]
#   Set the password to authenticate the username at the target.
#
# [*full_if_older_than*]
#   Forces a full backup if last full backup reaches a specified age.
#
# [*volsize*]
#   Set the size of backup chunks in MBs.
#
# [*include_filelist*]
#   List of files to be included in the backup.
#
# [*exclude_filelist*]
#   List of files to be excluded from the backup. Paths can be relative like '**/cache'.
#
# [*exclude_by_default*]
#   Exclude any file relative to the source directory that is not included; sets the '- **' parameter.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
define duplicity::profile(
  $ensure              = present,
  $gpg_encryption_keys = [],
  $gpg_signing_key     = undef,
  $gpg_passphrase      = '',
  $gpg_options         = [],
  $source              = '',
  $target              = '',
  $target_username     = '',
  $target_password     = '',
  $full_if_older_than  = '',
  $volsize             = 50,
  $include_filelist    = [],
  $exclude_filelist    = [],
  $exclude_by_default  = true,
) {
  require duplicity::params

  if $ensure !~ /^present|absent$/ {
    fail("Duplicity::Profile[${title}]: ensure must be either present or absent, got '${ensure}'")
  }

  if !is_array($gpg_encryption_keys) {
    fail("Duplicity::Profile[${title}]: gpg_encryption_keys must be an array, got '${gpg_encryption_keys}'")
  }

  if !empty($gpg_signing_key) and $gpg_signing_key !~ /^[a-zA-Z0-9]+$/ {
    fail("Duplicity::Profile[${title}]: signing_key must be alphanumeric, got '${gpg_signing_key}'")
  }

  if !is_array($gpg_options) {
    fail("Duplicity::Profile[${title}]: gpg_options must be an array")
  }

  if $ensure =~ /^present$/ and empty($source) {
    fail("Duplicity::Profile[${title}]: source must not be empty")
  }

  if $ensure =~ /^present$/ and empty($target) {
    fail("Duplicity::Profile[${title}]: target must not be empty")
  }

  if !is_integer($volsize) {
    fail("Duplicity::Profile[${title}]: volsize must be an integer, got '${volsize}'")
  }

  if !is_array($include_filelist) {
    fail("Duplicity::Profile[${title}]: include_filelist must be an array")
  }

  if !is_array($exclude_filelist) {
    fail("Duplicity::Profile[${title}]: exclude_filelist must be an array")
  }

  $profile_config_dir = "${duplicity::params::duply_config_dir}/${name}"
  $profile_config_dir_ensure = $ensure ? {
    absent  => absent,
    default => directory,
  }
  $profile_config_file = "${profile_config_dir}/conf"
  $profile_config_file_ensure = $ensure ? {
    absent  => absent,
    default => file,
  }
  $profile_file_list_file = "${profile_config_dir}/exclude"
  $profile_file_list_file_ensure = $ensure ? {
    absent  => absent,
    default => file,
  }
  $complete_encryption_keys = prefix($gpg_encryption_keys, "${title}/")
  $complete_signing_keys = prefix(delete_undef_values([$gpg_signing_key]), "${title}/")

  file { $profile_config_dir:
    ensure => $profile_config_dir_ensure,
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file { $profile_config_file:
    ensure  => $profile_config_file_ensure,
    content => template('duplicity/etc/duply/conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
  }

  file { $profile_file_list_file:
    ensure  => $profile_file_list_file_ensure,
    content => template('duplicity/etc/duply/exclude.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
  }

  duplicity::public_key_link { $complete_encryption_keys:
    ensure  => present,
  }

  duplicity::private_key_link { $complete_signing_keys:
    ensure  => present,
  }
}
