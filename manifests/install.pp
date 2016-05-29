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
    $real_duply_archive_name = "duply_${duplicity::duply_archive_version}"
    $real_duply_archive_url = empty($duplicity::duply_archive_url) ? {
      true    => "http://downloads.sourceforge.net/ftplicity/${real_duply_archive_name}.tgz",
      default => $duplicity::duply_archive_url,
    }
    $real_duply_executable_target = "${duplicity::duply_archive_install_dir}/${real_duply_archive_name}/duply"
    $real_duply_executable_ensure = $duplicity::duply_package_ensure ? {
      'absent' => absent,
      default  => link,
    }

    archive { $real_duply_archive_name:
      ensure           => $real_duply_package_ensure,
      url              => $real_duply_archive_url,
      proxy_server     => $duplicity::duply_archive_proxy,
      follow_redirects => true,
      extension        => 'tgz',
      target           => $duplicity::duply_archive_install_dir,
      src_target       => $duplicity::duply_archive_package_dir,
      digest_string    => $duplicity::duply_archive_md5sum,
    }

    file { $duplicity::duply_archive_executable:
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

    # If duply was previously installed from archive, it should not pollute the PATH any more ...
    file { $duplicity::duply_archive_executable:
      ensure => absent,
    }
  }
}
