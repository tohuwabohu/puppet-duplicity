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
  $duplicity_package_ensure = installed
  $duplicity_package_name = 'duplicity'

  $duply_package_ensure = $::osfamily ? {
    default => 'installed',
  }
  $duply_package_name = $::osfamily ? {
    default => 'duply',
  }
  $duply_package_provider = $::osfamily ? {
    'RedHat' => 'yum',
    'Debian' => 'apt',
    default  => 'archive'
  }
  $duply_extra_packages = []
  $duply_archive_version = '1.9.1'
  $duply_archive_checksum = 'b4a53f6ebc207185ae5c0b5f98bf46cf961def1a'
  $duply_archive_checksum_type = 'sha1'
  $duply_archive_install_dir = $::osfamily ? {
    default => '/opt',
  }
  $duply_archive_executable = $::osfamily ? {
    default => '/usr/local/sbin/duply',
  }
  $duply_config_dir = $::osfamily ? {
    default => '/etc/duply'
  }
  $duply_config_dir_mode = '0600'
  $duply_purge_config_dir = true
  $duply_profile_config_name = 'conf'
  $duply_profile_filelist_name = 'exclude'
  $duply_profile_pre_script_name = 'pre'
  $duply_profile_post_script_name = 'post'
  $duply_key_dir = $::osfamily ? {
    default => '/etc/duply-keys'
  }
  $duply_public_key_dir = "${duply_key_dir}/public"
  $duply_private_key_dir = "${duply_key_dir}/private"
  $duply_purge_key_dir = true
  $duply_use_logrotate_module = true
  $duply_log_dir = $::osfamily ? {
    default => '/var/log/duply'
  }
  $duply_log_group = $::osfamily ? {
    'redhat' => 'root',
    default  => 'adm',
  }

  case $::operatingsystem {
    'Debian': {
      $duply_version = $::lsbmajdistrelease ? {
        '7'     => '1.5.5.5',
        '8'     => '1.9.1',
        '9'     => '1.11.3',
        '10'    => '2.0.3',
        default => '1.11.3'
      }
    }
    'Ubuntu': {
      $duply_version = $::lsbdistrelease ? {
        '12.04' => '1.5.5.4',
        '14.04' => '1.5.10',
        '14.10' => '1.8.0',
        '15.04' => '1.9.1',
        '15.10' => '1.9.2',
        '16.04' => '1.11',
        default => '1.11',
      }
    }
    'CentOS': {
      $duply_version = $::operatingsystemmajrelease ? {
        '6' => '1.6.0',
        '7' => '1.11',
      }
    }
    default: {
      $duply_version = $duply_archive_version
    }
  }

  $gpg_encryption_keys = []
  $gpg_signing_key = ''
  $gpg_passphrase = ''
  $gpg_options = []
  $backup_target_url = ''
  $backup_target_username = ''
  $backup_target_password = ''

  $cron_enabled = false
  $exec_path = $::osfamily ? {
    default => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
  }
}
