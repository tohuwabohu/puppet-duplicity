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
# [*exclude_content*]
#   Raw content to set as the exclude file list. See 'man 1 duplicity', section 'FILE SELECTION'.
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
#   Deprecated, will be removed in the next major release.
#
# [*duply_environment*]
#   An array of extra environment variables to pass to duplicity.
#
# [*duplicity_extra_params*]
#   An array of extra parameters to pass to duplicity.
#
# [*duply_custom_batch*]
#   Custom batch command for Duply cron job. Batch format is '<command>[[_|+|-]<command>[_|+|-]...]' check Duply man page for details. 
#   Leave undefined for default batch: 'cleanup_backup_purgeFull'
#
# [*exec_before_content*]
#   Content to be added to the pre-backup script
#
# [*exec_before_source*]
#   Source file to be used as the pre-backup script
#
# [*exec_after_content*]
#   Content to be added to the post-backup script
#
# [*exec_after_source*]
#   Source file to be used as the post-backup script
#
# [*niceness*]
#   Nice value, -20 (most favorable scheduling) to 19 (least favorable) - disabled by default
#
# [*max_fulls_with_incrs*]
#   Number of full backups for which incrementals should be kept
#
# [*max_full_backups*]
#   Number of full backups to keep
#
# [*max_age*]
#   Maximum amount of time for which backups should be kept, e.g. 12M
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
define duplicity::profile(
  Enum['present', 'absent'] $ensure = present,
  Boolean $gpg_encryption = true,
  Variant[String, Array[String]] $gpg_encryption_keys = $duplicity::gpg_encryption_keys,
  String $gpg_signing_key = $duplicity::gpg_signing_key,
  String $gpg_passphrase = $duplicity::gpg_passphrase,
  Variant[String, Array[String]] $gpg_options = $duplicity::gpg_options,
  String $target = "${duplicity::backup_target_url}/${title}",
  String $target_username = $duplicity::backup_target_username,
  String $target_password = $duplicity::backup_target_password,
  String $source = '/',
  Variant[Integer, String] $full_if_older_than = '',
  Variant[Integer, String] $max_full_backups = '',
  Variant[Integer, String] $max_fulls_with_incrs = '',
  String $max_age = '',
  Integer $volsize = 50,
  Array[String] $include_filelist = [],
  Array[String ] $exclude_filelist = [],
  Optional[String] $exclude_content = undef,
  Boolean $exclude_by_default = true,
  Boolean $cron_enabled = $duplicity::cron_enabled,
  Optional[Variant[Integer, String, Array]] $cron_hour = undef,
  Optional[Variant[Integer, String]] $cron_minute = undef,
  Optional[String] $duply_version = undef,
  Array[String] $duply_environment = $duplicity::duply_environment,
  Array[String] $duplicity_extra_params = $duplicity::duplicity_extra_params,
  Optional[Stdlib::Absolutepath] $duply_cache_dir = $duplicity::duply_cache_dir,
  Optional[Stdlib::Absolutepath] $duply_temp_dir = $duplicity::duply_temp_dir,
  Optional[String] $duply_custom_batch = undef,
  Optional[String] $exec_before_content = undef,
  Optional[String] $exec_before_source = undef,
  Optional[String] $exec_after_content = undef,
  Optional[String] $exec_after_source = undef,
  Optional[Integer] $niceness = undef,
) {
  require duplicity

  if !empty($gpg_signing_key) and $gpg_signing_key !~ /^[a-zA-Z0-9]+$/ {
    fail("Duplicity::Profile[${title}]: signing_key must be alphanumeric, got '${gpg_signing_key}'")
  }

  if $ensure == 'present' {
    if empty($source) {
        fail("Duplicity::Profile[${title}]: source must not be empty")
    }

    if empty($target) {
      fail("Duplicity::Profile[${title}]: target must not be empty")
    }
  }

  $max_full_backups_str = String($max_full_backups)
  if !empty($max_full_backups_str) and "str${max_full_backups}" !~ /str[0-9]+/ {
    fail("Duplicity::Profile[${title}]: max_full_backups must be an integer, got '${max_full_backups}'")
  }

  $max_fulls_with_incrs_str = String($max_fulls_with_incrs)
  if !empty($max_fulls_with_incrs_str) and "str${max_fulls_with_incrs}" !~ /str[0-9]+/ {
    fail("Duplicity::Profile[${title}]: max_fulls_with_incrs must be an integer, got '${max_fulls_with_incrs}'")
  }

  if !empty($exclude_content) {
    if !empty($exclude_filelist) {
      fail("Duplicity::Profile[${title}]: exclude_content cannot be used together with exclude_filelist")
    }

    if !empty($include_filelist) {
      fail("Duplicity::Profile[${title}]: exclude_content cannot be used together with include_filelist")
    }
  }

  $real_duply_environment = empty($duply_environment) ? {
    true    => [],
    default => any2array($duply_environment)
  }

  $real_gpg_encryption_keys = empty($gpg_encryption_keys) ? {
    true    => [],
    default => any2array($gpg_encryption_keys)
  }
  $real_gpg_signing_keys = empty($gpg_signing_key) ? {
    true    => [],
    default => any2array($gpg_signing_key)
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
    'absent' => 'absent',
    default  => 'directory',
  }
  $profile_config_file = "${profile_config_dir}/conf"
  $profile_filelist_file = "${profile_config_dir}/${duplicity::params::duply_profile_filelist_name}"
  $profile_include_filelist = join(regsubst($include_filelist, '^(.+)$', "+ \\1\n"), '')
  $profile_exclude_filelist = join(regsubst($exclude_filelist, '^(.+)$', "- \\1\n"), '')
  $profile_pre_script = "${profile_config_dir}/${duplicity::params::duply_profile_pre_script_name}"
  $profile_post_script = "${profile_config_dir}/${duplicity::params::duply_profile_post_script_name}"
  $profile_file_ensure = $ensure ? {
    'absent' => 'absent',
    default  => 'file',
  }
  $profile_concat_ensure = $ensure ? {
    'absent' => 'absent',
    default  => 'present',
  }
  $cron_ensure = str2bool($cron_enabled) ? {
    false   => 'absent',
    default => 'present',
  }
  $exclude_by_default_ensure = $exclude_by_default ? {
    true    => 'present',
    default => 'absent',
  }
  $complete_encryption_keys = prefix($real_gpg_encryption_keys, "${title}/")
  $complete_signing_keys = prefix($real_gpg_signing_keys, "${title}/")

  file { $profile_config_dir:
    ensure => $profile_config_dir_ensure,
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file { $profile_config_file:
    ensure    => $profile_file_ensure,
    content   => template('duplicity/etc/duply/conf.erb'),
    owner     => 'root',
    group     => 'root',
    mode      => '0400',
    show_diff => false,
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

  if !empty($exclude_content) {
    concat::fragment { "${profile_filelist_file}/content":
      target  => $profile_filelist_file,
      content => $exclude_content,
      order   => '70',
    }
  }

  if $exclude_by_default_ensure == present {
    concat::fragment { "${profile_filelist_file}/exclude-by-default":
      target  => $profile_filelist_file,
      content => "\n- **\n",
      order   => '90',
    }
  }

  concat { $profile_pre_script:
    ensure         => $profile_concat_ensure,
    owner          => 'root',
    group          => 'root',
    mode           => '0700',
    ensure_newline => true,
  }

  if ! $exec_before_source {
    duplicity::profile_exec_before { "${title}/header":
      profile => $title,
      content => "#!/bin/bash\n",
      order   => '01',
    }
  }
  if $exec_before_content or $exec_before_source {
    duplicity::profile_exec_before { "${title}/content":
      profile => $title,
      content => $exec_before_content,
      source  => $exec_before_source,
    }
  }

  concat { $profile_post_script:
    ensure         => $profile_concat_ensure,
    owner          => 'root',
    group          => 'root',
    mode           => '0700',
    ensure_newline => true,
  }

  if ! $exec_after_source {
    duplicity::profile_exec_after { "${title}/header":
      profile => $title,
      content => "#!/bin/bash\n",
      order   => '01',
    }
  }
  if $exec_after_content or $exec_after_source {
    duplicity::profile_exec_after { "${title}/content":
      profile => $title,
      content => $exec_after_content,
      source  => $exec_after_source,
    }
  }

  duplicity::public_key_link { $complete_encryption_keys:
    ensure  => 'present',
  }

  duplicity::private_key_link { $complete_signing_keys:
    ensure  => 'present',
  }

  if $duply_custom_batch {
    $duply_batch = $duply_custom_batch
  }
  else {
    $duply_batch  = 'cleanup_backup_purgeFull'
  }

  if $duplicity::duply_log_output == 'logger' {
    $duply_command = "duply ${title} ${duply_batch} --force | logger -t \"${duplicity::duply_log_logger_tag}\""
  } else {
    $duply_command = "duply ${title} ${duply_batch} --force >> ${duplicity::duply_log_dir}/${title}.log"
  }

  if $niceness {
    $cron_command = "nice -n ${niceness} ${duply_command}"
  }
  else {
    $cron_command = $duply_command
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
