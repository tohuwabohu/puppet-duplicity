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
        duply_package_provider      => 'archive',
        duply_archive_version       => '2.1',
        duply_archive_checksum      => 'a8d2bfa907aacbef1c66bf1079fa24e541ad63f5d0694029e4596b030f3cb244',
        duply_archive_checksum_type => 'sha256'
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
