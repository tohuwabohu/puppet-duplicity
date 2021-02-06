# == Class: duplicity::params
#
# Default values of the duplicity class.
#
# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
class duplicity::params {
  $duplicity_package_ensure = 'installed'
  $duplicity_package_name = 'duplicity'
  $duply_package_ensure = 'installed'
  $duply_package_name = 'duply'
  $duply_package_provider = $facts['os']['family'] ? {
    'RedHat' => 'yum',
    'Debian' => 'apt',
    default  => 'archive'
  }
  $duply_extra_packages = []
  $duply_archive_version = '2.2.2'
  $duply_archive_checksum = '3cf4a2803173726b136b6fe030334bb42045b4d9'
  $duply_archive_checksum_type = 'sha1'
  $duply_archive_install_dir = '/opt'
  $duply_archive_executable = '/usr/local/sbin/duply'
  $duply_config_dir = '/etc/duply'
  $duply_config_dir_mode = '0600'
  $duply_purge_config_dir = true
  $duply_profile_config_name = 'conf'
  $duply_profile_filelist_name = 'exclude'
  $duply_profile_pre_script_name = 'pre'
  $duply_profile_post_script_name = 'post'
  $duply_key_dir = '/etc/duply-keys'
  $duply_public_key_dir = "${duply_key_dir}/public"
  $duply_private_key_dir = "${duply_key_dir}/private"
  $duply_purge_key_dir = true
  $duply_log_output = 'file'
  $duply_log_logger_tag = 'duply'
  $duply_use_logrotate_module = true
  $duply_log_dir = '/var/log/duply'
  $duply_log_group = $facts['os']['family'] ? {
    'redhat' => 'root',
    default  => 'adm',
  }

  $gpg_encryption_keys = []
  $gpg_signing_key = ''
  $gpg_passphrase = ''
  $gpg_options = []
  $backup_target_url = ''
  $backup_target_username = ''
  $backup_target_password = ''

  $cron_enabled = false
  $exec_path = '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
}
