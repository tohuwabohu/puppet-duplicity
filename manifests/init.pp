# == Class: duplicity
#
# Install and manage duplicity.
#
# === Parameters
#
# [*duplicity_package_ensure*]
#   Set state the package should be in.
#
# [*duplicity_package_name*]
#   Set the name of the package to be installed.
#
# [*duplicity_extra_params*]
#   An array of options to pass to the duplicity program.
#
# [*duply_package_ensure*]
#   Set state the package should be in. If the native `package` resource is used, the regular `ensure` rules apply.
#   When using the `archive` variant, only `present` and `absent` are supported. To specify a version in the later case
#   please use the `duply_archive_version` property.
#
# [*duply_package_name*]
#   Set the name of the package to be installed.
#
# [*duply_package_provider*]
#   Set the provider used to install the duply package. Use `archive` to download the package from a remote host
#   (defaults to the project's sourceforge page). Otherwise the native `package` resource will be used with `provider`
#   set to the given value.
#
# [*duply_archive_version*]
#   Set the version of duply to be installed (if `duply_package_provider` is set to `archive`).
#
# [*duply_archive_md5sum*]
#   Set the MD5 checksum of the archive (if `duply_package_provider` is set to `archive`).
#
# [*duply_archive_url*]
#   Set the full url where to download the archive from (if `duply_package_provider` is set to `archive`). Make sure the
#   downloaded filename matches the expected pattern.
#
# [*duply_archive_proxy*]
#   Set the proxy to use for archive download, in format `http://host:port` (if `duply_package_provider` is set to `archive`).
#
# [*duply_archive_package_dir*]
#   Set the directory where the downloaded package is stored (if `duply_package_provider` is set to `archive`).
#
# [*duply_archive_install_dir*]
#   Set the directory where the application is installed (if `duply_package_provider` is set to `archive`).
#
# [*duply_archive_executable*]
#   Set the symbolic path pointing to the configured duply executable when installing the archive from sourceforge.
#
# [*duply_executable*] *deprecated*
#   The duply executable is sourced from the PATH environment variable. Please use `exec_path` and
#   `duply_archive_executable` to customize those settings instead.
#
# [*duply_version*]
#   Set the version of the installed duply package in case you are not using the default package of your distribution or
#   your version is not automatically detected. If you are using `archive` as `duply_package_provider`, please
#   specify the version via `duply_archive_version`.
#
# [*duply_log_dir*]
#   Set the path to the log directory. Every profile will get its own log file.
#
# [*duply_cache_dir*]
#   Defines a folder that holds unencrypted meta data of the backup, enabling new incrementals without the
#   need to decrypt backend metadata first. If empty or deleted somehow, the private key and it's password are needed.
#   NOTE: This is confidential data. Put it somewhere safe. It can grow quite big over time so you might want to put
#   it not in the home dir. default '~/.cache/duplicity/duply_<profile>/'
#
# [*duply_purge_config_dir*]
#   Set the purge behaviour for duply configuration folder '/etc/duply'. default 'true'
#
# [*duply_purge_key_dir*]
#   Set the purge behaviour for duply key folder '/etc/duply-keys'. default 'true'
#
# [*duply_log_group*]
#   Set the group that owns the log directory.
#
# [*gpg_encryption_keys*]
#   List of default public keyids used to encrypt the backup.
#
# [*gpg_signing_key*]
#   Set the default keyid of the key used to sign the backup; default value unless specified per profile.
#
# [*gpg_passphrase*]
#   Set the default passphrase needed for signing, decryption and symmetric encryption.
#
# [*gpg_options*]
#   List of default options passed from duplicity to the gpg process; default value unless specified per profile
#
# [*backup_target_url*]
#   Set the default backup target where to store / find the backups. Expected to be an url like
#   scheme://host[:port]/[/]path. By default, the profile title will be appended at the end.
#
# [*backup_target_username*]
#   Set the default username used to authenticate with the backup target host.
#
# [*backup_target_password*]
#   Set the default password to authenticate the username at the backup target host.
#
# [*cron_enabled*]
#   Set the default state of the cron job. Either true or false.
#
# [*exec_path*]
#   Set the PATH passed to any exec resources.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
class duplicity (
  $duplicity_package_ensure  = $duplicity::params::duplicity_package_ensure,
  $duplicity_package_name    = $duplicity::params::duplicity_package_name,
  $duplicity_extra_params    = undef,
  $duply_package_ensure      = $duplicity::params::duply_package_ensure,
  $duply_package_name        = $duplicity::params::duply_package_name,
  $duply_package_provider    = $duplicity::params::duply_package_provider,
  $duply_archive_version     = $duplicity::params::duply_archive_version,
  $duply_archive_md5sum      = $duplicity::params::duply_archive_md5sum,
  $duply_archive_url         = undef,
  $duply_archive_proxy       = undef,
  $duply_archive_package_dir = $duplicity::params::duply_archive_package_dir,
  $duply_archive_install_dir = $duplicity::params::duply_archive_install_dir,
  $duply_version             = undef,
  $duply_archive_executable  = $duplicity::params::duply_archive_executable,
  $duply_log_dir             = $duplicity::params::duply_log_dir,
  $duply_log_group           = $duplicity::params::duply_log_group,
  $duply_cache_dir           = undef,
  $duply_purge_config_dir    = $duplicity::params::duply_purge_config_dir,
  $duply_purge_key_dir       = $duplicity::params::duply_purge_key_dir,
  $duply_environment         = undef,
  $duply_use_yo61_log_module = $duplicity::params::duply_use_yo61_log_module,
  $gpg_encryption_keys       = $duplicity::params::gpg_encryption_keys,
  $gpg_signing_key           = $duplicity::params::gpg_signing_key,
  $gpg_passphrase            = $duplicity::params::gpg_passphrase,
  $gpg_options               = $duplicity::params::gpg_options,
  $backup_target_url         = $duplicity::params::backup_target_url,
  $backup_target_username    = $duplicity::params::backup_target_username,
  $backup_target_password    = $duplicity::params::backup_target_password,
  $cron_enabled              = $duplicity::params::cron_enabled,
  $exec_path                 = $duplicity::params::exec_path,

  # deprecated
  $duply_executable = undef,
) inherits duplicity::params {
  if empty($duplicity_package_ensure) {
    fail('Class[Duplicity]: duplicity_package_ensure must not be empty')
  }

  if $duplicity_package_name !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Class[Duplicity]: duplicity_package_name must be alphanumeric, got '${duplicity_package_name}'")
  }

  if empty($duply_package_ensure) {
    fail('Class[Duplicity]: duply_package_ensure must not be empty')
  }

  if $duply_package_name !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Class[Duplicity]: duply_package_name must be alphanumeric, got '${duply_package_name}'")
  }

  if $duply_archive_version !~ /^[a-zA-Z0-9\._-]+$/ {
    fail("Class[Duplicity]: duply_archive_version must be alphanumeric, got '${duply_archive_version}'")
  }

  $real_duply_version = empty($duply_version) ? {
    true => $duply_package_provider ? {
      'archive' => $duply_archive_version,
      default   => $duplicity::params::duply_version,
    },
    default   => $duply_version,
  }

  validate_absolute_path($duply_archive_package_dir)
  validate_absolute_path($duply_archive_install_dir)
  validate_absolute_path($duply_archive_executable)
  validate_absolute_path($duply_log_dir)
  if ($duply_cache_dir) {
    validate_absolute_path($duply_cache_dir)
  }
  validate_string($duply_log_group)

  class { 'duplicity::install': } ->
  class { 'duplicity::setup': }
}
