require 'spec_helper'

describe 'duplicity::profile' do
  let(:title) { 'default' }
  let(:default_config_file) { '/etc/duply/default/conf' }
  let(:default_target) { 'http://example.com' }

  describe 'by default' do
    let(:params) { {:target => default_target} }

    it { should contain_file('/etc/duply/default').with_ensure('directory') }
    it { should contain_file('/etc/duply/default/conf').with_ensure('file') }
    it { should contain_file('/etc/duply/default/exclude').with_ensure('file') }
    it { should contain_file(default_config_file).with_content(/^GPG_KEYS_ENC=''$/) }
    it { should contain_file(default_config_file).with_content(/^GPG_KEY_SIGN='disabled'$/) }
    it { should contain_file(default_config_file).with_content(/^GPG_PW=''$/) }
    it { should contain_file(default_config_file).with_content(/^GPG_OPTS=''$/) }
    it { should contain_file(default_config_file).with_content(/^TARGET_USER=''$/) }
    it { should contain_file(default_config_file).with_content(/^TARGET_PASS=''$/) }
  end

  describe 'with ensure absent' do
    let(:params) { {:ensure => 'absent'} }

    it { should contain_file('/etc/duply/default').with_ensure('absent') }
    it { should contain_file('/etc/duply/default/conf').with_ensure('absent') }
    it { should contain_file('/etc/duply/default/exclude').with_ensure('absent') }
  end

  describe 'with invalid ensure' do
    let(:params) { {:ensure => 'foobar', :target => default_target} }

    it do
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /ensure/)
    end
  end

  describe 'with invalid gpg_encryption_keys' do
    let(:params) { {:gpg_encryption_keys => 'foobar', :target => default_target} }

    it do
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /gpg_encryption_keys/)
    end
  end

  describe 'with gpg_encryption_keys => [key1]' do
    let(:params) { {:gpg_encryption_keys => ['key1'], :target => default_target} }

    it { should contain_file(default_config_file).with_content(/^GPG_KEYS_ENC='key1'$/) }
  end

  describe 'with gpg_encryption_keys => [key1,key2]' do
    let(:params) { {:gpg_encryption_keys => ['key1', 'key2'], :target => default_target} }

    it { should contain_file(default_config_file).with_content(/^GPG_KEYS_ENC='key1,key2'$/) }
  end

  describe 'with invalid gpg_signing_key' do
    let(:params) { {:gpg_signing_key => 'invalid-key-id', :target => default_target} }

    it do
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /signing_key/)
    end
  end

  describe 'with gpg_signing_key => key1' do
    let(:params) { {:gpg_signing_key => 'key1', :target => default_target} }

    it { should contain_file(default_config_file).with_content(/^GPG_KEY_SIGN='key1'$/) }
  end

  describe 'with gpg_password => secret' do
    let(:params) { {:gpg_password => 'secret', :target => default_target} }

    it { should contain_file(default_config_file).with_content(/^GPG_PW='secret'$/) }
  end

  describe 'with gpg_options => [--switch]' do
    let(:params) { {:gpg_options => ['--switch'], :target => default_target} }

    it { should contain_file(default_config_file).with_content(/^GPG_OPTS='--switch'$/) }
  end

  describe 'with gpg_options => [--switch, --key=value]' do
    let(:params) { {:gpg_options => ['--switch', '--key=value'], :target => default_target} }

    it { should contain_file(default_config_file).with_content(/^GPG_OPTS='--switch --key=value'$/) }
  end

  describe 'with empty target' do
    let(:params) { {:target => ''} }

    it do
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /target/)
    end
  end

  describe 'with target => http://example.com' do
    let(:params) { {:target => 'http://example.com'} }

    it { should contain_file(default_config_file).with_content(/^TARGET='http:\/\/example.com'$/) }
  end

  describe 'with target_username => johndoe' do
    let(:params) { {:target_username => 'johndoe', :target => default_target} }

    it { should contain_file(default_config_file).with_content(/^TARGET_USER='johndoe'$/) }
  end

  describe 'with target_password => secret' do
    let(:params) { {:target_password => 'secret', :target => default_target} }

    it { should contain_file(default_config_file).with_content(/^TARGET_PASS='secret'$/) }
  end
end
