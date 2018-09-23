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
    $real_duply_package_ensure = $duplicity::duply_package_ensure ? {
      'absent' => absent,
      default  => present
    }
    $real_duply_executable_ensure = $duplicity::duply_package_ensure ? {
      'absent' => absent,
      default  => link,
    }
    $real_duply_archive_url = empty($duplicity::duply_archive_url) ? {
      true    => "http://downloads.sourceforge.net/ftplicity/duply_${duplicity::duply_archive_version}.tgz",
      default => $duplicity::duply_archive_url,
    }
    $duply_archive_filename = basename($real_duply_archive_url)
    $duply_install_dir = "${duplicity::duply_archive_install_dir}/duply_${duplicity::duply_archive_version}"

    archive { "/tmp/${duply_archive_filename}":
      ensure           => $real_duply_package_ensure,
      source           => $real_duply_archive_url,
      checksum         => $duplicity::duply_archive_checksum,
      checksum_type    => $duplicity::duply_archive_checksum_type,
      extract          => true,
      extract_path     => $duplicity::duply_archive_install_dir,
      creates          => $duply_install_dir,
      cleanup          => true,
      proxy_server     => $duplicity::duply_archive_proxy,
    }

    file { $duplicity::duply_archive_executable:
      ensure => $real_duply_executable_ensure,
      target => "${duply_install_dir}/duply",
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
      require  => Package['python-paramiko'],
    }
    # Note (arnaudmorin): we cannot ensure pyton-paramiko $duplicity::duply_package_ensure as
    # it can break if the package is already ensure present somewhere else in another module.
    ensure_packages ( ['python-paramiko'], {
      ensure   => present,
    })

    # If duply was previously installed from archive, it should not pollute the PATH any more ...
    file { $duplicity::duply_archive_executable:
      ensure => absent,
    }
  }

  # Install any additional packages that may be needed by the different backends
  ensure_packages($duplicity::duply_extra_packages, {'ensure' => 'present'})
}
