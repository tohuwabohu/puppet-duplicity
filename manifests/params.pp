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

  $duply_package_ensure = '1.7.3'
  $duply_package_name = 'duply-1.7.3'
  $duply_package_provider = archive
  $duply_archive_md5sum = '139e36c3ee35d8bca15b6aa9c7f8939b'
  $duply_archive_url = "https://www.dropbox.com/s/atfhw4hj5bev7n7/${duply_package_name}.tgz"
  $duply_archive_package_dir = $::operatingsystem ? {
    default => '/var/cache/puppet/archives',
  }
  $duply_archive_install_dir = $::osfamily ? {
    default => '/opt',
  }
  $duply_executable = $::osfamily ? {
    default => '/usr/local/sbin/duply'
  }
  $duply_config_dir = $::osfamily ? {
    default => '/etc/duply'
  }
  $duply_profile_config_name = 'conf'
  $duply_profile_filelist_name = 'exclude'
  $duply_profile_pre_script_name = 'pre'
  $duply_profile_post_script_name = 'post'
  $duply_key_dir = $::osfamily ? {
    default => '/etc/duply-keys'
  }
  $duply_public_key_dir = "${duply_key_dir}/public"
  $duply_private_key_dir = "${duply_key_dir}/private"
  $duply_log_dir = $::osfamily ? {
    default => '/var/log/duply'
  }

  $gzip_package_name = $::osfamily ? {
    default => 'gzip'
  }

  $mysql_option_file = $::osfamily ? {
    default => '/root/.my.cnf'
  }
  $mysql_backup_dir = $::osfamily ? {
    default => '/var/backups/mysql'
  }
  $mysql_client_package_name = $::osfamily ? {
    default => 'mysql-client'
  }
  $mysql_dump_script_path = $::osfamily ? {
    default => '/usr/local/sbin/dump-mysql-database.sh'
  }
  $mysql_dump_script_template = 'duplicity/usr/local/sbin/dump-mysql-database.sh.erb'

  $postgres_backup_dir = $::osfamily ? {
    default => '/var/backups/postgres'
  }
  $postgres_client_package_name = $::osfamly ? {
    default => 'postgresql-client'
  }
  $postgres_dump_script_path = $::osfamily ? {
    default => '/usr/local/sbin/dump-postgres-database.sh'
  }
  $postgres_dump_script_template = 'duplicity/usr/local/sbin/dump-postgres-database.sh.erb'
}
