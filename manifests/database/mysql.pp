# == Class: duplicity::database::mysql
#
# Manage scripts to work with MySQL databases.
#
# === Parameters
#
# [*dump_script_path*]
#   Set the path where to write the script to.
#
# [*dump_script_template*]
#   Set the template to be used when creating the dump script.
#
# [*option_file*]
#   Set the path to the option file containing username and password to access the database.
#
# [*backup_dir*]
#   Set the directory where to store the backup dump files.
#
# [*client_package_name*]
#   Set the name of the package which contains the pg_dump utility.
#
# [*gzip_package_name*]
#   Set the name of the package which contains the gzip utility.
#

# === Authors
#
# Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
class duplicity::database::mysql(
  $dump_script_path     = $duplicity::params::mysql_dump_script_path,
  $dump_script_template = $duplicity::params::mysql_dump_script_template,
  $option_file          = $duplicity::params::mysql_option_file,
  $backup_dir           = $duplicity::params::mysql_backup_dir,
  $client_package_name  = $duplicity::params::mysql_client_package_name,
  $gzip_package_name    = $duplicity::params::gzip_package_name,
) {
  require duplicity::params

  validate_absolute_path($dump_script_path)
  if empty($dump_script_template) {
    fail('Class[Duplicity::Database::Mysql]: dump_script_template must not be empty')
  }
  validate_absolute_path($option_file)
  validate_absolute_path($backup_dir)
  if empty($client_package_name) {
    fail('Class[Duplicity::Database::Mysql]: client_package_name must not be empty')
  }
  if empty($gzip_package_name) {
    fail('Class[Duplicity::Database::Mysql]: gzip_package_name must not be empty')
  }

  file { $dump_script_path:
    ensure  => file,
    content => template($dump_script_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => [
      File[$option_file],
      File[$backup_dir],
      Package[$client_package_name],
      Package[$gzip_package_name],
    ]
  }
}
