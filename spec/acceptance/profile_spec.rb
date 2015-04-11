require 'spec_helper_acceptance'

describe 'with profile and file' do
  let(:manifest) { <<-EOS
      class { 'duplicity':
        backup_target_url      => 'file:///tmp/duplicity/',
        backup_target_username => 'john',
        backup_target_password => 'doe',
      }

      duplicity::profile { 'system':
        gpg_encryption => false,
      }

      duplicity::file { '/etc/duply':
        ensure => backup,
      }
  EOS
  }

  specify 'should provision with no errors' do
    apply_manifest(manifest, :catch_failures => true)
  end

  specify 'should be idempotent' do
    apply_manifest(manifest, :catch_changes => true)
  end

  describe command('duply system status') do
    its(:exit_status) { should eq 0 }
  end

  describe command('duply system backup') do
    its(:exit_status) { should eq 0 }
  end
end
