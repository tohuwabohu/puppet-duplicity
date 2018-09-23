require 'spec_helper_acceptance'

describe 'with duply_package_provider => archive' do
  let(:manifest) { <<-EOS
      $required_directories = [
        '/var/cache/puppet',
        '/var/cache/puppet/archives',
      ]

      file { $required_directories:
        ensure => directory,
      }

      class { 'duplicity':
        duply_package_provider => 'archive',
        duply_archive_version  => '1.9.1',
        duply_archive_checksum => 'd584940b9c740c81a2a081bc154084b9',
      }
    EOS
  }

  specify 'should provision with no errors' do
    apply_manifest(manifest, :catch_failures => true)
  end

  specify 'should be idempotent' do
    apply_manifest(manifest, :catch_changes => true)
  end

  describe file('/usr/local/sbin/duply') do
    specify { should be_file }
    specify { should be_executable }
  end
end
