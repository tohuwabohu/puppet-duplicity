# == Class: duplicity::database::postgresql
#
# Manage scripts to work with PostgreSQL databases.
#
# === Parameters
#
# [*dump_script_path*]
#   Set the path where to write the script to.
#
# [*dump_script_template*]
#   Set the template to be used when creating the dump script.
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
class duplicity::database::postgresql(
  $dump_script_path     = $duplicity::params::postgresql_dump_script_path,
  $dump_script_template = $duplicity::params::postgresql_dump_script_template,
  $backup_dir           = $duplicity::params::postgresql_backup_dir,
  $client_package_name  = $duplicity::params::postgresql_client_package_name,
  $gzip_package_name    = $duplicity::params::gzip_package_name,
) {
  require duplicity::params

  validate_absolute_path($dump_script_path)
  if empty($dump_script_template) {
    fail('Class[Duplicity::Database::Postgresql]: dump_script_template must not be empty')
  }
  validate_absolute_path($backup_dir)
  if empty($client_package_name) {
    fail('Class[Duplicity::Database::Postgresql]: client_package_name must not be empty')
  }
  if empty($gzip_package_name) {
    fail('Class[Duplicity::Database::Postgresql]: gzip_package_name must not be empty')
  }

  file { $dump_script_path:
    ensure  => file,
    content => template($dump_script_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => [
      File[$backup_dir],
      Package[$client_package_name],
      Package[$gzip_package_name],
    ]
  }
}
