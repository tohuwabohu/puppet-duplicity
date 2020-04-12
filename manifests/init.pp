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
# [*duply_extra_packages*]
#   Additional packages to be installed which may be needed for storage backends on different platforms.
#
# [*duply_archive_version*]
#   Set the version of duply to be installed (if `duply_package_provider` is set to `archive`).
#
# [*duply_archive_checksum*]
#   Set the checksum digest of the archive (if `duply_package_provider` is set to `archive`).
#
# [*duply_archive_checksum_type*]
#   Set the checksum type of the archive, eg 'md5' or 'sha1' (if `duply_package_provider` is set to `archive`).
#
# [*duply_archive_url*]
#   Set the full url where to download the archive from (if `duply_package_provider` is set to `archive`). Make sure the
#   downloaded filename matches the expected pattern.
#
# [*duply_archive_proxy*]
#   Set the proxy to use for archive download, in format `http://host:port` (if `duply_package_provider` is set to `archive`).
#
# [*duply_archive_install_dir*]
#   Set the directory where the application is installed (if `duply_package_provider` is set to `archive`).
#
# [*duply_archive_executable*]
#   Set the symbolic path pointing to the configured duply executable when installing the archive from sourceforge.
#
# [*duply_version*]
#   Deprecated, will be removed in the next major release.
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
# [*duply_config_dir_mode*]
#   Set the mode for duply configuration folder '/etc/duply'. This is a file mode, puppet will add +x for directories
#   automatically. default '0600'
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
# [*duply_use_logrotate_module*]
#   Set if puppet/logrotate module is used or logrotate file is created by puppet template.
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
  String $duplicity_package_ensure = $duplicity::params::duplicity_package_ensure,
  String $duplicity_package_name = $duplicity::params::duplicity_package_name,
  Array[String] $duplicity_extra_params = [],
  String $duply_package_ensure = $duplicity::params::duply_package_ensure,
  String $duply_package_name = $duplicity::params::duply_package_name,
  String $duply_package_provider = $duplicity::params::duply_package_provider,
  Array[String] $duply_extra_packages = $duplicity::params::duply_extra_packages,
  String $duply_archive_version = $duplicity::params::duply_archive_version,
  String $duply_archive_checksum = $duplicity::params::duply_archive_checksum,
  String $duply_archive_checksum_type = $duplicity::params::duply_archive_checksum_type,
  Optional[String] $duply_archive_url = undef,
  Optional[String] $duply_archive_proxy = undef,
  Stdlib::Absolutepath $duply_archive_install_dir = $duplicity::params::duply_archive_install_dir,
  Optional[String] $duply_version = undef,
  Stdlib::Absolutepath $duply_archive_executable = $duplicity::params::duply_archive_executable,
  Stdlib::Absolutepath $duply_log_dir = $duplicity::params::duply_log_dir,
  String $duply_log_group = $duplicity::params::duply_log_group,
  Optional[Stdlib::Absolutepath] $duply_cache_dir = undef,
  Optional[Stdlib::Absolutepath] $duply_temp_dir = undef,
  String $duply_config_dir_mode = $duplicity::params::duply_config_dir_mode,
  Boolean $duply_purge_config_dir = $duplicity::params::duply_purge_config_dir,
  Boolean $duply_purge_key_dir = $duplicity::params::duply_purge_key_dir,
  Array[String] $duply_environment = [],
  Boolean $duply_use_logrotate_module = $duplicity::params::duply_use_logrotate_module,
  Variant[String, Array[String]] $gpg_encryption_keys = $duplicity::params::gpg_encryption_keys,
  String $gpg_signing_key = $duplicity::params::gpg_signing_key,
  String $gpg_passphrase = $duplicity::params::gpg_passphrase,
  Variant[String, Array[String]] $gpg_options = $duplicity::params::gpg_options,
  String $backup_target_url = $duplicity::params::backup_target_url,
  String $backup_target_username = $duplicity::params::backup_target_username,
  String $backup_target_password = $duplicity::params::backup_target_password,
  Boolean $cron_enabled = $duplicity::params::cron_enabled,
  String $exec_path = $duplicity::params::exec_path,
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

  class { 'duplicity::install': }
  -> class { 'duplicity::setup': }
}
