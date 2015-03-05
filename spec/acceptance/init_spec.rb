require 'spec_helper_acceptance'

describe 'by default' do
  let(:manifest) { "class { 'duplicity': }" }

  specify 'should provision with no errors' do
    apply_manifest(manifest, :catch_failures => true)
  end

  specify 'should be idempotent' do
    apply_manifest(manifest, :catch_changes => true)
  end

  describe package('duplicity') do
    specify { should be_installed }
  end

  describe package('duply') do
    specify { should be_installed }
  end

  describe file('/usr/bin/duply') do
    specify { should be_file }
    specify { should be_executable }
  end

  describe file('/etc/duply') do
    specify { should be_directory }
  end

  describe file('/etc/duply-keys') do
    specify { should be_directory }
  end

  describe file('/etc/duply-keys/private') do
    specify { should be_directory }
  end

  describe file('/etc/duply-keys/public') do
    specify { should be_directory }
  end

  describe file('/var/log/duply') do
    specify { should be_directory }
  end
end
