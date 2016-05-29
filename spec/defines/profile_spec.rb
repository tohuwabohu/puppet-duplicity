require 'spec_helper'

describe 'duplicity::profile' do
  let(:title) { 'default' }
  let(:facts) { {:concat_basedir => '/path/to/dir'} }
  let(:default_config_file) { '/etc/duply/default/conf' }
  let(:default_filelist) { '/etc/duply/default/exclude' }

  describe 'by default' do
    let(:params) { {} }

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
    it { should contain_file(default_config_file).with_content(/^# GPG_KEY='disabled'/) }
    it { should contain_file(default_config_file).with_content(/^GPG_KEYS_ENC=''$/) }
    it { should contain_file(default_config_file).with_content(/^GPG_KEY_SIGN='disabled'$/) }
    it { should contain_file(default_config_file).with_content(/^GPG_PW=''$/) }
    it { should contain_file(default_config_file).with_content(/^GPG_OPTS=''$/) }
    it { should contain_file(default_config_file).with_content(/^TARGET_USER=''$/) }
    it { should contain_file(default_config_file).with_content(/^TARGET_PASS=''$/) }
    it { should contain_file(default_config_file).without_content(/^MAX_FULLBKP_AGE=.*$/) }
    it { should contain_file(default_config_file).without_content(/^MAX_FULL_BACKUPS=.*$/) }
    it { should contain_file(default_config_file).with_content(/^VOLSIZE=50$/) }
    it { should contain_concat__fragment("#{default_filelist}/exclude-by-default").with_content(/^\n\- \*\*$/) }
    it { should_not contain_concat__fragment("#{default_filelist}/include") }
    it { should_not contain_concat__fragment("#{default_filelist}/exclude") }
    specify { should contain_cron("backup-default").with_ensure('absent') }
    specify { should contain_file(default_config_file).with_content(/^SOURCE='\/'$/) }
    specify { should contain_file(default_config_file).with_content(/^TARGET='\/default'$/) }
    it { should contain_duplicity__profile_exec_before('default/header') }
    it { should_not contain_duplicity__profile_exec_before('default/content') }
    it { should contain_duplicity__profile_exec_after('default/header') }
    it { should_not contain_duplicity__profile_exec_after('default/content') }
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
    let(:params) { {:ensure => 'foobar'} }

    it do
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /ensure/)
    end
  end

  describe 'with duplicity_extra_params defined' do
    let(:params) { {:duplicity_extra_params => [ '--s3-use-3-use-server-side-encryption' ]} }

    it do
      should contain_file('/etc/duply/default/conf')
      .with('content' => /DUPL_PARAMS --s3-use-3-use-server-side-encryption/)
    end
  end

  describe 'with gpg_encryption => false' do
    let(:params) { {:gpg_encryption => false} }

    it { should contain_file(default_config_file).with_content(/^GPG_KEY='disabled'$/) }
  end

  describe 'with gpg_encryption => true' do
    let(:params) { {:gpg_encryption => true} }

    it { should contain_file(default_config_file).with_content(/^# GPG_KEY='disabled'/) }
  end

  describe 'with empty gpg_encryption_keys' do
    let(:params) { {:gpg_encryption_keys => ''} }

    it { should contain_file(default_config_file).with_content(/^GPG_KEYS_ENC=''$/) }
  end

  describe 'with gpg_encryption_keys => key1' do
    let(:params) { {:gpg_encryption_keys => 'key1'} }

    it { should contain_file(default_config_file).with_content(/^GPG_KEYS_ENC='key1'$/) }
    it { should contain_duplicity__public_key_link('default/key1') }
  end

  describe 'with gpg_encryption_keys => [key1]' do
    let(:params) { {:gpg_encryption_keys => ['key1']} }

    it { should contain_file(default_config_file).with_content(/^GPG_KEYS_ENC='key1'$/) }
    it { should contain_duplicity__public_key_link('default/key1') }
  end

  describe 'with gpg_encryption_keys => [key1,key2]' do
    let(:params) { {:gpg_encryption_keys => ['key1', 'key2']} }

    it { should contain_file(default_config_file).with_content(/^GPG_KEYS_ENC='key1,key2'$/) }
    it { should contain_duplicity__public_key_link('default/key1') }
    it { should contain_duplicity__public_key_link('default/key2') }
  end

  describe 'with invalid gpg_signing_key' do
    let(:params) { {:gpg_signing_key => 'invalid-key-id'} }

    it do
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /signing_key/)
    end
  end

  describe 'with gpg_signing_key => key1' do
    let(:params) { {:gpg_signing_key => 'key1'} }

    it { should contain_file(default_config_file).with_content(/^GPG_KEY_SIGN='key1'$/) }
    it { should contain_duplicity__private_key_link('default/key1') }
  end

  describe 'with gpg_passphrase => secret' do
    let(:params) { {:gpg_passphrase => 'secret'} }

    it { should contain_file(default_config_file).with_content(/^GPG_PW='secret'$/) }
  end

  describe 'with empty gpg_options' do
    let(:params) { {:gpg_options => ''} }

    specify { should contain_file(default_config_file).with_content(/^GPG_OPTS=''$/) }
  end

  describe 'with gpg_options => --switch' do
    let(:params) { {:gpg_options => '--switch'} }

    specify { should contain_file(default_config_file).with_content(/^GPG_OPTS='--switch'$/) }
  end

  describe 'with gpg_options => [--switch]' do
    let(:params) { {:gpg_options => ['--switch']} }

    it { should contain_file(default_config_file).with_content(/^GPG_OPTS='--switch'$/) }
  end

  describe 'with gpg_options => [--switch, --key=value]' do
    let(:params) { {:gpg_options => ['--switch', '--key=value']} }

    it { should contain_file(default_config_file).with_content(/^GPG_OPTS='--switch --key=value'$/) }
  end

  describe 'with empty source' do
    let(:params) { {:source => '' } }

    it do
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /source/)
    end
  end

  describe 'with source => /path/of/source' do
    let(:params) { {:source => '/path/of/source', } }

    it { should contain_file(default_config_file).with_content(/^SOURCE='\/path\/of\/source'$/) }
  end

  describe 'with empty target' do
    let(:params) { {:target => '', } }

    it do
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /target/)
    end
  end

  describe 'with target => http://example.com' do
    let(:params) { {:target => 'http://example.com', } }

    it { should contain_file(default_config_file).with_content(/^TARGET='http:\/\/example.com'$/) }
  end

  describe 'with target_username => johndoe' do
    let(:params) { {:target_username => 'johndoe'} }

    it { should contain_file(default_config_file).with_content(/^TARGET_USER='johndoe'$/) }
  end

  describe 'with target_password => secret' do
    let(:params) { {:target_password => 'secret'} }

    it { should contain_file(default_config_file).with_content(/^TARGET_PASS='secret'$/) }
  end

  describe 'should accept max_full_backups as integer' do
    let(:params) { {:max_full_backups => 5} }

    it { should contain_file(default_config_file).with_content(/^MAX_FULL_BACKUPS=5$/) }
  end

  describe 'should accept max_full_backups as string' do
    let(:params) { {:max_full_backups => '5'} }

    it { should contain_file(default_config_file).with_content(/^MAX_FULL_BACKUPS=5$/) }
  end

  describe 'should not accept any string as max_full_backups' do
    let(:params) { {:max_full_backups => 'invalid'} }

    specify {
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /max_full_backups/)
    }
  end

  describe 'with full_if_older_than => 1M' do
    let(:params) { {:full_if_older_than => '1M'} }

    it { should contain_file(default_config_file).with_content(/^MAX_FULLBKP_AGE=1M$/) }
    it { should contain_file(default_config_file).with_content(/^DUPL_PARAMS="\$DUPL_PARAMS --full-if-older-than \$MAX_FULLBKP_AGE "$/) }
  end

  describe 'with invalid volsize' do
    let(:params) { {:volsize => 'invalid'} }

    specify {
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /volsize/)
    }
  end

  describe 'with volsize => 25' do
    let(:params) { {:volsize => 25} }

    it { should contain_file(default_config_file).with_content(/^VOLSIZE=25$/) }
    it { should contain_file(default_config_file).with_content(/^DUPL_PARAMS="\$DUPL_PARAMS --volsize \$VOLSIZE "$/) }
  end

  describe 'with include_files => "/a/b"' do
    let(:params) { {:include_filelist => ['/a/b']} }

    it { should contain_concat__fragment("#{default_filelist}/include").with_content(/^\+ \/a\/b$/) }
  end

  describe 'with invalid include_filelist' do
    let(:params) { {:include_filelist => 'invalid'} }

    specify {
      expect { should contain_concat__fragment("#{default_filelist}/include") }.to raise_error(Puppet::Error, /include_filelist/)
    }
  end

  describe 'with exclude_files => "/a/b"' do
    let(:params) { {:exclude_filelist => ['/a/b']} }

    it { should contain_concat__fragment("#{default_filelist}/exclude").with_content(/^\- \/a\/b$/) }
  end

  describe 'with invalid exclude_filelist' do
    let(:params) { {:exclude_filelist => 'invalid'} }

    specify {
      expect { should contain_concat__fragment("#{default_filelist}/exclude") }.to raise_error(Puppet::Error, /exclude_filelist/)
    }
  end

  describe 'with exclude_by_default => false' do
    let(:params) { {:exclude_by_default => false} }

    it { should contain_concat__fragment("#{default_filelist}/exclude-by-default").with_ensure('absent') }
  end

  describe 'with cron_enabled and cron_hour and cron_minute set' do
    let(:params) { {:cron_enabled => true, :cron_hour => '1', :cron_minute => '2'} }

    specify do
      should contain_cron("backup-default").with(
        'ensure' => 'present',
        'hour'   => '1',
        'minute' => '2'
      )
    end
  end

  describe 'with pre and post script contents' do
    let(:params) { { :exec_before_content => 'echo stuff', :exec_after_content => 'echo "more stuff"' } }
    it { should contain_duplicity__profile_exec_before('default/header') }
    it { should contain_duplicity__profile_exec_before('default/content') }
    it { should contain_duplicity__profile_exec_after('default/header') }
    it { should contain_duplicity__profile_exec_after('default/content') }
  end

  describe 'with pre and post script source' do
    let(:params) { { :exec_before_source => 'puppet:///a', :exec_after_source => 'puppet:///b' } }
    it { should_not contain_duplicity__profile_exec_before('default/header') }
    it { should contain_duplicity__profile_exec_before('default/content') }
    it { should_not contain_duplicity__profile_exec_after('default/header') }
    it { should contain_duplicity__profile_exec_after('default/content') }
  end

  describe 'with cron_enabled and duply_version 1.7.1' do
    let(:params) { {:cron_enabled => true, :duply_version => '1.7.1'} }

    specify do
      should contain_cron("backup-default").with(
        'ensure'  => 'present',
	'command' => 'duply default cleanup_backup_purgeFull --force >> /var/log/duply/default.log'
      )
    end
  end

  describe 'with cron_enabled and duply_version 1.9.1' do
    let(:params) { {:cron_enabled => true, :duply_version => '1.9.1'} }

    specify do
      should contain_cron("backup-default").with(
        'ensure'  => 'present',
	'command' => 'duply default cleanup_backup_purgeFull --force >> /var/log/duply/default.log'
      )
    end
  end

  describe 'with cron_enabled and duply_version 1.6' do
    let(:params) { {:cron_enabled => true, :duply_version => '1.6'} }

    specify do
      should contain_cron("backup-default").with(
        'ensure'  => 'present',
	'command' => 'duply default cleanup_backup_purge-full --force >> /var/log/duply/default.log'
      )
    end
  end
end
