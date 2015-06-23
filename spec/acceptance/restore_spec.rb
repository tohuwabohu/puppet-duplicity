require 'spec_helper_acceptance'

describe 'duplicity::file can restore from backup' do
  before {
    shell('rm -rf /tmp/{duplicity,restore-me}')
    shell('mkdir -p /tmp/restore-me/dummy')
    apply_manifest("
          class { 'duplicity':
            backup_target_url      => 'file:///tmp/duplicity/',
            backup_target_username => 'john',
            backup_target_password => 'doe',
          }

          duplicity::profile { 'system':
            gpg_encryption => false,
          }

          duplicity::file { '/tmp/restore-me':
            ensure => backup,
          }
    ", :catch_failures => true)
    shell('duply system backup')
    shell('rm -rf /tmp/restore-me')
  }

  specify 'with default package provider' do
    manifest = <<-EOS
          class { 'duplicity':
            backup_target_url      => 'file:///tmp/duplicity/',
            backup_target_username => 'john',
            backup_target_password => 'doe',
          }

          duplicity::profile { 'system':
            gpg_encryption => false,
          }

          duplicity::file { '/tmp/restore-me': }
    EOS
    apply_manifest(manifest, :catch_failures => true)
  end

  specify 'with archive package provider' do
    manifest = <<-EOS
          class { 'duplicity':
            duply_package_provider => 'archive',
            backup_target_url      => 'file:///tmp/duplicity/',
            backup_target_username => 'john',
            backup_target_password => 'doe',
          }

          duplicity::profile { 'system':
            gpg_encryption => false,
          }

          duplicity::file { '/tmp/restore-me': }
    EOS
    apply_manifest(manifest, :catch_failures => true)
  end
end
