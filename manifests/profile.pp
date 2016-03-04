# == Class: duplicity::profile
#
# Configure a backup profile.
#
# === Parameters
#
# [*ensure*]
#   Set state the profile should be in. Either present or absent.
#
# [*gpg_encryption*]
#   Enable or disable GPG encryption of backups. Defaults to 'true'.
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
#   Set the base directory to backup. Defaults to the root directory of the filesystem.
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
# [*cron_enabled*]
#   Set the state of the cron job. Either true or false.
#
# [*cron_hour*]
#   The hour expression of the cron job.
#
# [*cron_minute*]
#   The minute expression of the cron job.
#
# [*duply_version*]
#   Currently installed duply version.
#
# [*duplicity_extra_params*]
#   An array of extra parameters to pass to duplicity.
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
  $ensure                 = present,
  $gpg_encryption         = true,
  $gpg_encryption_keys    = $duplicity::gpg_encryption_keys,
  $gpg_signing_key        = $duplicity::gpg_signing_key,
  $gpg_passphrase         = $duplicity::gpg_passphrase,
  $gpg_options            = $duplicity::gpg_options,
  $target                 = "${duplicity::backup_target_url}/${title}",
  $target_username        = $duplicity::backup_target_username,
  $target_password        = $duplicity::backup_target_password,
  $source                 = '/',
  $full_if_older_than     = '',
  $max_full_backups       = '',
  $volsize                = 50,
  $include_filelist       = [],
  $exclude_filelist       = [],
  $exclude_by_default     = true,
  $cron_enabled           = $duplicity::cron_enabled,
  $cron_hour              = undef,
  $cron_minute            = undef,
  $duply_version          = $duplicity::real_duply_version,
  $duplicity_extra_params = $duplicity::duplicity_extra_params,
  $duply_cache_dir        = $duplicity::duply_cache_dir,
) {
  require duplicity

  if $ensure !~ /^present|absent$/ {
    fail("Duplicity::Profile[${title}]: ensure must be either present or absent, got '${ensure}'")
  }

  if !empty($gpg_signing_key) and $gpg_signing_key !~ /^[a-zA-Z0-9]+$/ {
    fail("Duplicity::Profile[${title}]: signing_key must be alphanumeric, got '${gpg_signing_key}'")
  }

  if $ensure =~ /^present$/ and empty($source) {
    fail("Duplicity::Profile[${title}]: source must not be empty")
  }

  if $ensure =~ /^present$/ and empty($target) {
    fail("Duplicity::Profile[${title}]: target must not be empty")
  }

  if !empty($max_full_backups) and !is_integer($max_full_backups) {
    fail("Duplicity::Profile[${title}]: max_full_backups must be an integer, got '${max_full_backups}'")
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

  if !is_bool($gpg_encryption) {
    fail("Duplicity::Profile[${title}]: gpg_encryption must be true or false")
  }


  $real_gpg_encryption_keys = empty($gpg_encryption_keys) ? {
    true    => [],
    default => any2array($gpg_encryption_keys)
  }
  $real_gpg_signing_key = empty($gpg_signing_key) ? {
    true    => undef,
    default => $gpg_signing_key
  }
  $real_gpg_options = empty($gpg_options) ? {
    true    => [],
    default => any2array($gpg_options)
  }
  $real_duplicity_params = empty($duplicity_extra_params) ? {
    true    => [],
    default => any2array($duplicity_extra_params)
  }

  $profile_config_dir = "${duplicity::params::duply_config_dir}/${title}"
  $profile_config_dir_ensure = $ensure ? {
    absent  => absent,
    default => directory,
  }
  $profile_config_file = "${profile_config_dir}/conf"
  $profile_filelist_file = "${profile_config_dir}/${duplicity::params::duply_profile_filelist_name}"
  $profile_include_filelist = join(regsubst($include_filelist, '^(.+)$', "+ \\1\n"), '')
  $profile_exclude_filelist = join(regsubst($exclude_filelist, '^(.+)$', "- \\1\n"), '')
  $profile_pre_script = "${profile_config_dir}/${duplicity::params::duply_profile_pre_script_name}"
  $profile_post_script = "${profile_config_dir}/${duplicity::params::duply_profile_post_script_name}"
  $profile_file_ensure = $ensure ? {
    absent  => absent,
    default => file,
  }
  $profile_concat_ensure = $ensure ? {
    absent  => absent,
    default => present,
  }
  $cron_ensure = str2bool($cron_enabled) ? {
    false   => absent,
    default => present,
  }
  $exclude_by_default_ensure = $exclude_by_default ? {
    true    => present,
    default => absent,
  }
  $complete_encryption_keys = prefix($real_gpg_encryption_keys, "${title}/")
  $complete_signing_keys = prefix(delete_undef_values([$real_gpg_signing_key]), "${title}/")

  file { $profile_config_dir:
    ensure => $profile_config_dir_ensure,
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file { $profile_config_file:
    ensure  => $profile_file_ensure,
    content => template('duplicity/etc/duply/conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
  }

  concat { $profile_filelist_file:
    ensure         => $profile_concat_ensure,
    owner          => 'root',
    group          => 'root',
    mode           => '0400',
    ensure_newline => true,
  }

  concat::fragment { "${profile_filelist_file}/header":
    target  => $profile_filelist_file,
    content => template('duplicity/etc/duply/exclude.erb'),
    order   => '01',
  }

  if !empty($profile_exclude_filelist) {
    concat::fragment { "${profile_filelist_file}/exclude":
      target  => $profile_filelist_file,
      content => $profile_exclude_filelist,
      order   => '10',
    }
  }

  if !empty($profile_include_filelist) {
    concat::fragment { "${profile_filelist_file}/include":
      target  => $profile_filelist_file,
      content => $profile_include_filelist,
      order   => '50',
    }
  }

  concat::fragment { "${profile_filelist_file}/exclude-by-default":
    ensure  => $exclude_by_default_ensure,
    target  => $profile_filelist_file,
    content => "\n- **\n",
    order   => '90',
  }

  concat { $profile_pre_script:
    ensure         => $profile_concat_ensure,
    owner          => 'root',
    group          => 'root',
    mode           => '0700',
    ensure_newline => true,
  }

  duplicity::profile_exec_before { "${title}/header":
    profile => $title,
    content => "#!/bin/bash\n",
    order   => '01',
  }

  concat { $profile_post_script:
    ensure         => $profile_concat_ensure,
    owner          => 'root',
    group          => 'root',
    mode           => '0700',
    ensure_newline => true,
  }

  duplicity::profile_exec_after { "${title}/header":
    profile => $title,
    content => "#!/bin/bash\n",
    order   => '01',
  }

  duplicity::public_key_link { $complete_encryption_keys:
    ensure  => present,
  }

  duplicity::private_key_link { $complete_signing_keys:
    ensure  => present,
  }

  if versioncmp($duply_version, '1.7.1') < 0 {
    $cron_command  = "duply ${title} cleanup_backup_purge-full --force >> ${duplicity::duply_log_dir}/${title}.log"
  }
  else {
    $cron_command  = "duply ${title} cleanup_backup_purgeFull --force >> ${duplicity::duply_log_dir}/${title}.log"
  }

  cron { "backup-${title}":
    ensure      => $cron_ensure,
    command     => $cron_command,
    environment => "PATH=${duplicity::exec_path}",
    user        => 'root',
    hour        => $cron_hour,
    minute      => $cron_minute,
  }
}
