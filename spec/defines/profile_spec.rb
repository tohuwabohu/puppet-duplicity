require 'spec_helper'

describe 'duplicity::profile' do
  let(:title) { 'default' }
  let(:default_config_file) { '/etc/duply/default/conf' }

  describe 'by default' do
    let(:params) { {} }

    it { should contain_file('/etc/duply/default').with_ensure('directory') }
    it { should contain_file('/etc/duply/default/conf').with_ensure('file') }
    it { should contain_file('/etc/duply/default/exclude').with_ensure('file') }
  end

  describe 'with ensure absent' do
    let(:params) { {:ensure => 'absent'} }

    it { should contain_file('/etc/duply/default').with_ensure('absent') }
    it { should contain_file('/etc/duply/default/conf').with_ensure('absent') }
    it { should contain_file('/etc/duply/default/exclude').with_ensure('absent') }
  end

  describe 'with invalid ensure' do
    let(:params) { {:ensure => 'foobar'} }

    it do
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /ensure/)
    end
  end

  describe 'with invalid gpg_encryption_keys' do
    let(:params) { {:gpg_encryption_keys => 'foobar'} }

    it do
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /gpg_encryption_keys/)
    end
  end

  describe 'with empty gpg_encryption_keys' do
    let(:params) { {:gpg_encryption_keys => []} }

    it { should contain_file(default_config_file).with_content(/^GPG_KEYS_ENC=''$/) }
  end

  describe 'with gpg_encryption_keys => [key1]' do
    let(:params) { {:gpg_encryption_keys => ['key1']} }

    it { should contain_file(default_config_file).with_content(/^GPG_KEYS_ENC='key1'$/) }
  end

  describe 'with gpg_encryption_keys => [key1,key2]' do
    let(:params) { {:gpg_encryption_keys => ['key1', 'key2']} }

    it { should contain_file(default_config_file).with_content(/^GPG_KEYS_ENC='key1,key2'$/) }
  end

  describe 'with invalid gpg_signing_key' do
    let(:params) { {:gpg_signing_key => 'invalid-key-id'} }

    it do
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /signing_key/)
    end
  end

  describe 'with empty gpg_signing_key' do
    let(:params) { {:gpg_signing_key => ''} }

    it { should contain_file(default_config_file).with_content(/^GPG_KEY_SIGN='disabled'$/) }
  end

  describe 'with gpg_signing_key => key1' do
    let(:params) { {:gpg_signing_key => 'key1'} }

    it { should contain_file(default_config_file).with_content(/^GPG_KEY_SIGN='key1'$/) }
  end

  describe 'with empty gpg_password' do
    let(:params) { {:gpg_password => ''} }

    it { should contain_file(default_config_file).with_content(/^GPG_PW=''$/) }
  end

  describe 'with gpg_password => secret' do
    let(:params) { {:gpg_password => 'secret'} }

    it { should contain_file(default_config_file).with_content(/^GPG_PW='secret'$/) }
  end
end
