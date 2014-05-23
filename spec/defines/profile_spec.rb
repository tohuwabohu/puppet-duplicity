require 'spec_helper'

describe 'duplicity::profile' do
  let(:title) { 'default' }
  let(:facts) { {:concat_basedir => '/path/to/dir'} }
  let(:default_config_file) { '/etc/duply/default/conf' }
  let(:default_filelist) { '/etc/duply/default/exclude' }
  let(:a_source) { '/path/of/source' }
  let(:a_target) { 'http://example.com' }

  describe 'by default' do
    let(:params) { {:source => a_source, :target => a_target} }

    it {
      should contain_file('/etc/duply/default').with(
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0700'
      )
    }
    it {
      should contain_file('/etc/duply/default/conf').with(
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0400'
      )
    }
    it {
      should contain_concat('/etc/duply/default/exclude').with(
        'ensure' => 'present',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0400'
      )
    }
    it {
      should contain_concat('/etc/duply/default/pre').with(
        'ensure' => 'present',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0700'
      )
    }
    it {
      should contain_concat('/etc/duply/default/post').with(
        'ensure' => 'present',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0700'
      )
    }
    it { should contain_file(default_config_file).with_content(/^GPG_KEYS_ENC=''$/) }
    it { should contain_file(default_config_file).with_content(/^GPG_KEY_SIGN='disabled'$/) }
    it { should contain_file(default_config_file).with_content(/^GPG_PW=''$/) }
    it { should contain_file(default_config_file).with_content(/^GPG_OPTS=''$/) }
    it { should contain_file(default_config_file).with_content(/^TARGET_USER=''$/) }
    it { should contain_file(default_config_file).with_content(/^TARGET_PASS=''$/) }
    it { should contain_file(default_config_file).without_content(/^MAX_FULLBKP_AGE=.*$/) }
    it { should contain_file(default_config_file).with_content(/^VOLSIZE=50$/) }
    it { should contain_concat__fragment("#{default_filelist}/exclude-by-default").with_content(/^\- \*\*$/) }
  end

  describe 'with ensure absent' do
    let(:params) { {:ensure => 'absent'} }

    it { should contain_file('/etc/duply/default').with_ensure('absent') }
    it { should contain_file('/etc/duply/default/conf').with_ensure('absent') }
    it { should contain_file('/etc/duply/default/exclude').with_ensure('absent') }
    it { should contain_file('/etc/duply/default/pre').with_ensure('absent') }
    it { should contain_file('/etc/duply/default/post').with_ensure('absent') }
  end

  describe 'with invalid ensure' do
    let(:params) { {:ensure => 'foobar', :source => a_source, :target => a_target} }

    it do
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /ensure/)
    end
  end

  describe 'with invalid gpg_encryption_keys' do
    let(:params) { {:gpg_encryption_keys => 'foobar', :source => a_source, :target => a_target} }

    it do
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /gpg_encryption_keys/)
    end
  end

  describe 'with gpg_encryption_keys => [key1]' do
    let(:params) { {:gpg_encryption_keys => ['key1'], :source => a_source, :target => a_target} }

    it { should contain_file(default_config_file).with_content(/^GPG_KEYS_ENC='key1'$/) }
    it { should contain_duplicity__public_key_link('default/key1') }
  end

  describe 'with gpg_encryption_keys => [key1,key2]' do
    let(:params) { {:gpg_encryption_keys => ['key1', 'key2'], :source => a_source, :target => a_target} }

    it { should contain_file(default_config_file).with_content(/^GPG_KEYS_ENC='key1,key2'$/) }
    it { should contain_duplicity__public_key_link('default/key1') }
    it { should contain_duplicity__public_key_link('default/key2') }
  end

  describe 'with invalid gpg_signing_key' do
    let(:params) { {:gpg_signing_key => 'invalid-key-id', :source => a_source, :target => a_target} }

    it do
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /signing_key/)
    end
  end

  describe 'with gpg_signing_key => key1' do
    let(:params) { {:gpg_signing_key => 'key1', :source => a_source, :target => a_target} }

    it { should contain_file(default_config_file).with_content(/^GPG_KEY_SIGN='key1'$/) }
    it { should contain_duplicity__private_key_link('default/key1') }
  end

  describe 'with gpg_passphrase => secret' do
    let(:params) { {:gpg_passphrase => 'secret', :source => a_source, :target => a_target} }

    it { should contain_file(default_config_file).with_content(/^GPG_PW='secret'$/) }
  end

  describe 'with invalid gpg_options' do
    let(:params) { {:gpg_options => '--switch', :source => a_source, :target => a_target} }

    specify {
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /gpg_options/)
    }
  end

  describe 'with gpg_options => [--switch]' do
    let(:params) { {:gpg_options => ['--switch'], :source => a_source, :target => a_target} }

    it { should contain_file(default_config_file).with_content(/^GPG_OPTS='--switch'$/) }
  end

  describe 'with gpg_options => [--switch, --key=value]' do
    let(:params) { {:gpg_options => ['--switch', '--key=value'], :source => a_source, :target => a_target} }

    it { should contain_file(default_config_file).with_content(/^GPG_OPTS='--switch --key=value'$/) }
  end

  describe 'with empty source' do
    let(:params) { {:source => '', :target => a_target } }

    it do
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /source/)
    end
  end

  describe 'with source => /path/of/source' do
    let(:params) { {:source => '/path/of/source', :target => a_target, } }

    it { should contain_file(default_config_file).with_content(/^SOURCE='\/path\/of\/source'$/) }
  end

  describe 'with empty target' do
    let(:params) { {:target => '', :source => a_source, } }

    it do
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /target/)
    end
  end

  describe 'with target => http://example.com' do
    let(:params) { {:target => 'http://example.com', :source => a_source, } }

    it { should contain_file(default_config_file).with_content(/^TARGET='http:\/\/example.com'$/) }
  end

  describe 'with target_username => johndoe' do
    let(:params) { {:target_username => 'johndoe', :source => a_source, :target => a_target} }

    it { should contain_file(default_config_file).with_content(/^TARGET_USER='johndoe'$/) }
  end

  describe 'with target_password => secret' do
    let(:params) { {:target_password => 'secret', :source => a_source, :target => a_target} }

    it { should contain_file(default_config_file).with_content(/^TARGET_PASS='secret'$/) }
  end

  describe 'with full_if_older_than => 1M' do
    let(:params) { {:full_if_older_than => '1M', :source => a_source, :target => a_target} }

    it { should contain_file(default_config_file).with_content(/^MAX_FULLBKP_AGE=1M$/) }
    it { should contain_file(default_config_file).with_content(/^DUPL_PARAMS="\$DUPL_PARAMS --full-if-older-than \$MAX_FULLBKP_AGE "$/) }
  end

  describe 'with invalid volsize' do
    let(:params) { {:volsize => 'invalid', :source => a_source, :target => a_target} }

    specify {
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /volsize/)
    }
  end

  describe 'with volsize => 25' do
    let(:params) { {:volsize => 25, :source => a_source, :target => a_target} }

    it { should contain_file(default_config_file).with_content(/^VOLSIZE=25$/) }
    it { should contain_file(default_config_file).with_content(/^DUPL_PARAMS="\$DUPL_PARAMS --volsize \$VOLSIZE "$/) }
  end

  describe 'with include_files => "/a/b"' do
    let(:params) { {:include_filelist => ['/a/b'], :source => a_source, :target => a_target} }

    it { should contain_concat__fragment("#{default_filelist}/include").with_content(/^\+ \/a\/b$/) }
  end

  describe 'with invalid include_filelist' do
    let(:params) { {:include_filelist => 'invalid', :source => a_source, :target => a_target} }

    specify {
      expect { should contain_concat__fragment("#{default_filelist}/include") }.to raise_error(Puppet::Error, /include_filelist/)
    }
  end

  describe 'with exclude_files => "/a/b"' do
    let(:params) { {:exclude_filelist => ['/a/b'], :source => a_source, :target => a_target} }

    it { should contain_concat__fragment("#{default_filelist}/exclude").with_content(/^\- \/a\/b$/) }
  end

  describe 'with invalid exclude_filelist' do
    let(:params) { {:exclude_filelist => 'invalid', :source => a_source, :target => a_target} }

    specify {
      expect { should contain_concat__fragment("#{default_filelist}/exclude") }.to raise_error(Puppet::Error, /exclude_filelist/)
    }
  end

  describe 'with exclude_by_default => false' do
    let(:params) { {:exclude_by_default => false, :source => a_source, :target => a_target} }

    it { should contain_concat__fragment("#{default_filelist}/exclude-by-default").with_ensure('absent') }
  end
end
