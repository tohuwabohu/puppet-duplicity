# = Class: duplicity::install
#
# Installs duplicity and duply.
#
# == Author
#
#   Martin Meinhold <Martin.Meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2014 Martin Meinhold, unless otherwise noted.
#
class duplicity::install inherits duplicity {
  package { 'duplicity':
    ensure => $duplicity::duplicity_package_ensure,
    name   => $duplicity::duplicity_package_name,
  }

  if $duplicity::duply_package_provider == archive {
    $real_duply_package_version = $duplicity::duply_package_ensure
    $real_duply_package_ensure = $duplicity::duply_package_ensure ? {
      absent  => absent,
      default => present
    }
    $real_duply_archive_root_dir = "duply_${real_duply_package_version}"
    $real_duply_executable_target = "${duplicity::duply_archive_install_dir}/${real_duply_archive_root_dir}/duply"
    $real_duply_executable_ensure = $duplicity::duply_package_ensure ? {
      absent  => absent,
      default => link,
    }

    archive { $duplicity::duply_package_name:
      ensure        => $real_duply_package_ensure,
      url           => $duplicity::duply_archive_url,
      extension     => 'tgz',
      root_dir      => $real_duply_archive_root_dir,
      target        => $duplicity::duply_archive_install_dir,
      src_target    => $duplicity::duply_archive_package_dir,
      digest_string => $duplicity::duply_archive_md5sum,
    }

    file { $duplicity::duply_executable:
      ensure => $real_duply_executable_ensure,
      target => $real_duply_executable_target,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
  }
  else {
    package { 'duply':
      ensure   => $duplicity::duply_package_ensure,
      name     => $duplicity::duply_package_name,
      provider => $duplicity::duply_package_provider,
    }
  }
}
